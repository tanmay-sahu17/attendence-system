import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _flashEnabled = false;
  bool _isInitialized = false;
  
  // Lecture details
  bool _showLectureForm = true;
  DateTime? _selectedDate;
  String? _lectureNumber;
  final _lectureNumberController = TextEditingController();

  // Photo capture
  List<String> _capturedPhotos = [];
  final int _requiredPhotos = 30;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }
  
  void _proceedToCamera() {
    if (_selectedDate == null || _lectureNumber == null || _lectureNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and enter lecture number')),
      );
      return;
    }
    setState(() {
      _showLectureForm = false;
    });
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _lectureNumberController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) return;
    if (_capturedPhotos.length >= _requiredPhotos) {
      _showSubmitDialog();
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/attendance_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      final image = await _controller!.takePicture();
      await File(image.path).copy(path);
      
      setState(() {
        _capturedPhotos.add(path);
        _isCapturing = false;
      });

      if (_capturedPhotos.length >= _requiredPhotos) {
        // Auto-show submit dialog when all 30 photos are captured
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showSubmitDialog();
          }
        });
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      setState(() {
        _isCapturing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing photo: $e')),
        );
      }
    }
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'All Photos Captured!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B3544),
          ),
        ),
        content: Text(
          'You have captured all $_requiredPhotos photos. Ready to submit for processing?',
          style: const TextStyle(color: Color(0xFF7D8897)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7D8897))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/processing');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A4FB8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _attemptSubmit() {
    final remaining = _requiredPhotos - _capturedPhotos.length;
    if (remaining > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFE84545)),
              SizedBox(width: 8),
              Text(
                'Incomplete',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B3544),
                ),
              ),
            ],
          ),
          content: Text(
            'Please capture the remaining $remaining photo${remaining > 1 ? 's' : ''} before submitting for processing.',
            style: const TextStyle(color: Color(0xFF7D8897)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A4FB8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Continue Capturing'),
            ),
          ],
        ),
      );
    } else {
      context.push('/processing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A4FB8),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _showLectureForm ? 'Lecture Details' : 'Record Attendance',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _showLectureForm ? _buildLectureForm() : _buildCameraView(),
    );
  }

  Widget _buildLectureForm() {
    return Container(
      color: const Color(0xFFF7F9FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1A4FB8),
                    Color(0xFF00BFFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A4FB8).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Set Lecture Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter the date and lecture number',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lecture Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD9DCE3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Selection
                    const Text(
                      'Lecture Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3544),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF1A4FB8),
                                  onPrimary: Colors.white,
                                  onSurface: Color(0xFF2B3544),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD9DCE3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF1A4FB8),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select Date',
                              style: TextStyle(
                                fontSize: 15,
                                color: _selectedDate != null
                                    ? const Color(0xFF2B3544)
                                    : const Color(0xFF7D8897),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF7D8897),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lecture Number
                    const Text(
                      'Lecture Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3544),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _lectureNumberController,
                      decoration: InputDecoration(
                        hintText: 'Enter lecture number (e.g., 1, 2, 3)',
                        hintStyle: const TextStyle(
                          color: Color(0xFF7D8897),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.numbers,
                          color: Color(0xFF1A4FB8),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F9FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9DCE3),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9DCE3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1A4FB8),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF2B3544),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _lectureNumber = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _proceedToCamera();
                    },
                    icon: const Icon(Icons.camera_alt, size: 20),
                    label: const Text('Capture Photos'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A4FB8),
                      side: const BorderSide(color: Color(0xFF1A4FB8), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedDate == null || _lectureNumber == null || _lectureNumber!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select date and enter lecture number')),
                        );
                        return;
                      }
                      context.push('/upload');
                    },
                    icon: const Icon(Icons.upload, size: 20),
                    label: const Text('Upload Photos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A4FB8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        // Camera Preview
        Expanded(
          child: Container(
            color: const Color(0xFFF7F9FB),
            child: Center(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF1A4FB8).withOpacity(0.2),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Camera Preview or Placeholder
                      if (_isInitialized && _controller != null)
                        CameraPreview(_controller!)
                      else
                        Container(
                          color: const Color(0xFFF7F9FB),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 64,
                                  color: Color(0xFF1A4FB8),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Camera Preview',
                                  style: TextStyle(
                                    color: Color(0xFF7D8897),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Photo Progress Indicator
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _capturedPhotos.length >= _requiredPhotos
                                    ? [const Color(0xFF33CC66), const Color(0xFF2DB55D)]
                                    : [const Color(0xFF1A4FB8), const Color(0xFF00BFFF)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _capturedPhotos.length >= _requiredPhotos
                                      ? Icons.check_circle
                                      : Icons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_capturedPhotos.length} / $_requiredPhotos',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Progress Bar at Bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: _capturedPhotos.length / _requiredPhotos,
                          backgroundColor: Colors.black.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _capturedPhotos.length >= _requiredPhotos
                                ? const Color(0xFF33CC66)
                                : const Color(0xFF00BFFF),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Controls
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFD9DCE3),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Flash Toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD9DCE3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: _flashEnabled
                            ? const Color(0xFF00BFFF)
                            : const Color(0xFF7D8897),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Flash',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _flashEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _flashEnabled = value;
                          });
                          if (_controller != null) {
                            await _controller!.setFlashMode(
                              value ? FlashMode.torch : FlashMode.off,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Capture Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Capture Photo Button
                    GestureDetector(
                      onTap: _isCapturing ? null : _capturePhoto,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _capturedPhotos.length >= _requiredPhotos
                                ? [const Color(0xFF33CC66), const Color(0xFF2DB55D)]
                                : [const Color(0xFF1A4FB8), const Color(0xFF00BFFF)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_capturedPhotos.length >= _requiredPhotos
                                      ? const Color(0xFF33CC66)
                                      : const Color(0xFF1A4FB8))
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isCapturing
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : Icon(
                                  _capturedPhotos.length >= _requiredPhotos
                                      ? Icons.check_circle
                                      : Icons.camera,
                                  size: 40,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    if (_capturedPhotos.isNotEmpty) ...[
                      const SizedBox(width: 24),
                      // Submit Button
                      GestureDetector(
                        onTap: _attemptSubmit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: _capturedPhotos.length >= _requiredPhotos
                                ? const Color(0xFF1A4FB8)
                                : const Color(0xFF7D8897),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (_capturedPhotos.length >= _requiredPhotos
                                        ? const Color(0xFF1A4FB8)
                                        : const Color(0xFF7D8897))
                                    .withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _capturedPhotos.length >= _requiredPhotos
                      ? 'All photos captured! Tap Submit to proceed'
                      : 'Tap to capture photo (${_capturedPhotos.length}/$_requiredPhotos)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7D8897),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
