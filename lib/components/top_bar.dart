import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final canPop = currentRoute != '/';

    return AppBar(
      backgroundColor: const Color(0xFF0A192F),
      foregroundColor: Colors.white,
      elevation: 2,
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFFF).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'FaceMark AI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            'Smart Attendance',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            context.push('/profile');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
