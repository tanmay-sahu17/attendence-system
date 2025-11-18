import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final List<XFile> _selectedPhotos = [];
  final int _requiredPhotos = 10;
  bool _isLoading = false;

  Future<void> _pickPhotos(BuildContext context) async {
    final picker = ImagePicker();
    
    setState(() {
      _isLoading = true;
    });

    try {
      final photos = await picker.pickMultiImage();
      
      if (photos.isNotEmpty && context.mounted) {
        setState(() {
          _selectedPhotos.addAll(photos);
          _isLoading = false;
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${photos.length} photo(s) selected')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting photos: $e')),
        );
      }
    }
  }

  void _submit(BuildContext context) {
    final remaining = _requiredPhotos - _selectedPhotos.length;
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
            'Please select the remaining $remaining photo${remaining > 1 ? 's' : ''} before submitting for processing.',
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
              child: const Text('Continue Selecting'),
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
        title: const Text(
          'Upload Photos',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F9FB),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular Progress Indicator
                    if (_selectedPhotos.isNotEmpty)
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: _selectedPhotos.length / _requiredPhotos,
                          strokeWidth: 6,
                          backgroundColor: const Color(0xFFD9DCE3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _selectedPhotos.length >= _requiredPhotos
                                ? const Color(0xFF28A745)
                                : const Color(0xFF00BFFF),
                          ),
                        ),
                      ),
                    // Icon
                    Icon(
                      _selectedPhotos.length >= _requiredPhotos
                          ? Icons.check_circle
                          : Icons.cloud_upload,
                      size: 60,
                      color: _selectedPhotos.length >= _requiredPhotos
                          ? const Color(0xFF28A745)
                          : const Color(0xFF7D8897),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Upload Attendance Photos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3544),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedPhotos.isEmpty
                      ? 'Select 10 photos from your gallery to process attendance'
                      : '${_selectedPhotos.length} / $_requiredPhotos photos selected',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7D8897),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // Select Photos Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A4FB8).withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _pickPhotos(context),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1A4FB8),
                              ),
                            )
                          : const Icon(Icons.photo_library, size: 20),
                      label: Text(
                        _selectedPhotos.isEmpty ? 'Select Photos' : 'Add More Photos',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7D8897),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                
                if (_selectedPhotos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (_selectedPhotos.length >= _requiredPhotos
                                ? const Color(0xFF28A745)
                                : const Color(0xFF7D8897)).withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _submit(context),
                        icon: const Icon(Icons.check_circle, size: 20),
                        label: const Text(
                          'Submit for Processing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF7D8897),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Clear Button
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPhotos.clear();
                      });
                    },
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE84545),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
