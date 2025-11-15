import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isRecording = false;
  int _recordingTime = 0;
  Timer? _timer;
  bool _flashEnabled = false;
  bool _isInitialized = false;
  
  // Lecture details
  bool _showLectureForm = true;
  DateTime? _selectedDate;
  String? _lectureNumber;
  final _lectureNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }
  
  void _proceedToRecording() {
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
        enableAudio: true,
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
    _timer?.cancel();
    _controller?.dispose();
    _lectureNumberController.dispose();
    super.dispose();
  }

  void _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordingTime = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingTime++;
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording started')),
      );
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  void _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      await _controller!.stopVideoRecording();
      _timer?.cancel();
      setState(() {
        _isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording stopped')),
      );

      if (mounted) {
        context.push('/processing');
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
                      _proceedToRecording();
                    },
                    icon: const Icon(Icons.videocam, size: 20),
                    label: const Text('Record Video'),
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
                    icon: const Icon(Icons.cloud_upload, size: 20),
                    label: const Text('Upload Video'),
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

                      // Recording Overlay
                      if (_isRecording)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF00BFFF).withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF00BFFF),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),

                      // Recording Indicator
                      if (_isRecording)
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE84545),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTime(_recordingTime),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

                // Record Button
                GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE84545),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE84545).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isRecording
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording
                      ? 'Tap to stop recording'
                      : 'Tap to start recording',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7D8897),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
