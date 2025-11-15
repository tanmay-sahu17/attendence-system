import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  void _startProcessing() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.pushReplacement('/results');
            }
          });
        }
      } else {
        setState(() {
          _progress += 0.01;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Container(
        color: const Color(0xFFF7F9FB),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFFD9DCE3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1A4FB8),
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1A4FB8),
                              Color(0xFF00BFFF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1A4FB8).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Processing Attendance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3544),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'AI is analyzing faces...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7D8897),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A4FB8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
