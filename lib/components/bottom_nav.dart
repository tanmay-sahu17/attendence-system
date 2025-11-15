import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFD9DCE3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                path: '/',
                isActive: currentRoute == '/',
              ),
              _NavItem(
                icon: Icons.description,
                label: 'Records',
                path: '/records',
                isActive: currentRoute == '/records',
              ),
              _NavItem(
                icon: Icons.settings,
                label: 'Settings',
                path: '/settings',
                isActive: currentRoute == '/settings',
              ),
              _NavItem(
                icon: Icons.person,
                label: 'Profile',
                path: '/profile',
                isActive: currentRoute == '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(path),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF1A4FB8).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? const Color(0xFF1A4FB8)
                  : const Color(0xFF7D8897),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF1A4FB8)
                    : const Color(0xFF7D8897),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
