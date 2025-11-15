import 'package:flutter/material.dart';

class MobileContainer extends StatelessWidget {
  final Widget child;

  const MobileContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A4FB8).withOpacity(0.3),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 428),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FB),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
