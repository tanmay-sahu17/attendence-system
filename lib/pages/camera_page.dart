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
  String? _subjectName;
  String? _lectureNumber;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _subjectNameController = TextEditingController();
  final _lectureNumberController = TextEditingController();

  // Video recording
  String? _recordedVideoPath;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }
  
  void _proceedToCamera() {
    if (_subjectName == null || _subjectName!.isEmpty || 
        _lectureNumber == null || _lectureNumber!.isEmpty ||
        _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
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
        ResolutionPreset.medium, // Changed from high to medium to reduce buffer usage
        enableAudio: true, // Enable audio for video recording
        imageFormatGroup: ImageFormatGroup.jpeg, // Specify JPEG format
      );

      await _controller!.initialize();
      
      // Set flash mode based on current state
      await _controller!.setFlashMode(_flashEnabled ? FlashMode.torch : FlashMode.off);
      
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
    // Properly dispose camera controller
    _controller?.dispose();
    _subjectNameController.dispose();
    _lectureNumberController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // Pause camera when widget is deactivated
    _controller?.pausePreview();
    super.deactivate();
  }

  Future<void> _toggleVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_isRecording) {
      // Stop recording
      try {
        final XFile videoFile = await _controller!.stopVideoRecording();
        
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/attendance_${DateTime.now().millisecondsSinceEpoch}.mp4';
        
        // Copy file to permanent location
        await File(videoFile.path).copy(path);
        
        // Delete original temp file
        try {
          await File(videoFile.path).delete();
        } catch (e) {
          debugPrint('Error deleting temp file: $e');
        }
        
        setState(() {
          _recordedVideoPath = path;
          _isRecording = false;
        });
        
        // Show submit dialog
        _showSubmitDialog();
      } catch (e) {
        debugPrint('Error stopping video: $e');
        setState(() {
          _isRecording = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error stopping video: $e')),
          );
        }
      }
    } else {
      // Start recording
      try {
        setState(() {
          _isRecording = true;
        });
        
        // Check if already recording
        if (_controller!.value.isRecordingVideo) {
          await _controller!.stopVideoRecording();
        }
        
        // Start recording video
        await _controller!.startVideoRecording();
      } catch (e) {
        debugPrint('Error starting video: $e');
        setState(() {
          _isRecording = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error starting video: $e')),
          );
        }
      }
    }
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Video Recorded!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B3544),
          ),
        ),
        content: const Text(
          'Your attendance video has been recorded. Ready to submit for processing?',
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
              backgroundColor: const Color(0xFF0A192F),
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
    if (_recordedVideoPath == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Color(0xFFFFC107)),
              SizedBox(width: 8),
              Text(
                'No Video Recorded',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B3544),
                ),
              ),
            ],
          ),
          content: const Text(
            'Please record a video before submitting for processing.',
            style: TextStyle(color: Color(0xFF7D8897)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Color(0xFF0A192F))),
            ),
          ],
        ),
      );
      return;
    }
    context.push('/processing');
  }

  void _attemptSubmitOld() {
    final remaining = 0;
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
            'Please record the remaining $remaining video${remaining > 1 ? 's' : ''} before submitting for processing.',
            style: const TextStyle(color: Color(0xFF7D8897)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A192F),
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
        backgroundColor: const Color(0xFF0A192F),
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
      color: const Color(0xFFF0F4F8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A192F), Color(0xFF1E3A5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0A192F).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 32,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Set Lecture Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Enter the date and lecture number',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                    // Subject Name
                    const Text(
                      'Subject Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3544),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _subjectNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter subject name (e.g., Mathematics)',
                        hintStyle: const TextStyle(
                          color: Color(0xFF7D8897),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.book,
                          color: Color(0xFF0A192F),
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
                            color: Color(0xFF0A192F),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF2B3544),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _subjectName = value;
                        });
                      },
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
                          color: Color(0xFF0A192F),
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
                            color: Color(0xFF0A192F),
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
                    const SizedBox(height: 24),

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
                                  primary: Color(0xFF0A192F),
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
                              color: Color(0xFFFFC107),
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

                    // Time Selection
                    const Text(
                      'Lecture Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3544),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF0A192F),
                                  onPrimary: Colors.white,
                                  onSurface: Color(0xFF2B3544),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
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
                              Icons.access_time,
                              color: Color(0xFFFFC107),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Select Time',
                              style: TextStyle(
                                fontSize: 15,
                                color: _selectedTime != null
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
                    icon: const Icon(Icons.videocam, size: 20),
                    label: const Text('Record Videos'),
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
                      if (_subjectName == null || _subjectName!.isEmpty ||
                          _lectureNumber == null || _lectureNumber!.isEmpty ||
                          _selectedDate == null || _selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      context.push('/upload');
                    },
                    icon: const Icon(Icons.upload, size: 20),
                    label: const Text('Upload Videos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A192F),
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
    return Stack(
      children: [
        // Full Screen Camera Preview
        Positioned.fill(
          child: _isInitialized && _controller != null
              ? CameraPreview(_controller!)
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 64,
                          color: Colors.white54,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Camera Preview',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        // Video Recording Indicator at Top
        Positioned(
          top: 60,
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
                  colors: _isRecording
                      ? [const Color(0xFFE84545), const Color(0xFFC62828)]
                      : _recordedVideoPath != null
                      ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                      : [const Color(0xFF0A192F), const Color(0xFF1E3A5F)],
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
                    _isRecording
                        ? Icons.fiber_manual_record
                        : _recordedVideoPath != null
                        ? Icons.check_circle
                        : Icons.videocam,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isRecording
                        ? 'Recording...'
                        : _recordedVideoPath != null
                        ? 'Video Recorded'
                        : 'Ready to Record',
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

        // Floating Flash Toggle (Top Right)
        Positioned(
          top: 60,
          right: 20,
          child: GestureDetector(
            onTap: () async {
              setState(() {
                _flashEnabled = !_flashEnabled;
              });
              if (_controller != null) {
                await _controller!.setFlashMode(
                  _flashEnabled ? FlashMode.torch : FlashMode.off,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _flashEnabled
                      ? const Color(0xFFFFC107)
                      : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                _flashEnabled ? Icons.flash_on : Icons.flash_off,
                color: _flashEnabled ? const Color(0xFFFFC107) : Colors.white,
                size: 28,
              ),
            ),
          ),
        ),

        // Floating Capture Button (Bottom Center)
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isRecording
                      ? 'Tap to stop recording'
                      : _recordedVideoPath != null
                      ? 'Video recorded! Tap Submit to proceed'
                      : 'Tap to start recording video',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Record/Stop Video Button
                    GestureDetector(
                      onTap: _toggleVideoRecording,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isRecording
                                ? [const Color(0xFFE84545), const Color(0xFFC62828)]
                                : _recordedVideoPath != null
                                ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                                : [const Color(0xFF0A192F), const Color(0xFF1E3A5F)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording
                                      ? const Color(0xFFE84545)
                                      : _recordedVideoPath != null
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFF0A192F))
                                  .withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _isRecording
                                ? Icons.stop
                                : _recordedVideoPath != null
                                ? Icons.check_circle
                                : Icons.videocam,
                                  size: 40,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    if (_recordedVideoPath != null) ...[
                      const SizedBox(width: 24),
                      // Submit Button
                      GestureDetector(
                        onTap: _attemptSubmit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
