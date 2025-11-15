import 'package:flutter/material.dart';
import '../components/top_bar.dart';
import '../components/bottom_nav.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: const Color(0xFFF7F9FB),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B3544),
              ),
            ),
            const SizedBox(height: 24),
          _SettingsSection(
            title: 'Appearance',
            items: [
              _SettingsItem(
                icon: Icons.brightness_6,
                title: 'Theme',
                subtitle: 'System default',
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'Recognition',
            items: [
              _SettingsItem(
                icon: Icons.face,
                title: 'Face Detection Sensitivity',
                subtitle: 'High',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.timer,
                title: 'Recognition Timeout',
                subtitle: '10 seconds',
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'Notifications',
            items: [
              _SettingsItem(
                icon: Icons.notifications,
                title: 'Push Notifications',
                subtitle: 'Enabled',
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: 'About',
            items: [
              _SettingsItem(
                icon: Icons.info,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.description,
                title: 'Terms of Service',
                onTap: () {},
              ),
            ],
          ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B3544),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD9DCE3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A4FB8)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF2B3544),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7D8897),
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF7D8897)),
      onTap: onTap,
    );
  }
}
