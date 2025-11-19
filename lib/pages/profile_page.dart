import 'package:flutter/material.dart';
import '../components/top_bar.dart';
import '../components/bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: const TopBar(),
      body: Container(
        color: const Color(0xFFF0F4F8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Profile Header
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
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF0A192F).withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF0A192F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Teacher Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'teacher@school.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7D8897),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(label: 'Classes', value: '3'),
                          _StatItem(label: 'Students', value: '120'),
                          _StatItem(label: 'Sessions', value: '45'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Profile Actions
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
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: Color(0xFF0A192F)),
                      title: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF7D8897)),
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: Color(0xFFD9DCE3)),
                    ListTile(
                      leading: const Icon(Icons.lock, color: Color(0xFF0A192F)),
                      title: const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF7D8897)),
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: Color(0xFFD9DCE3)),
                    ListTile(
                      leading: const Icon(Icons.school, color: Color(0xFF0A192F)),
                      title: const Text(
                        'Manage Classes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF7D8897)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE84545),
                    side: const BorderSide(
                      color: Color(0xFFE84545),
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE84545),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A192F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF7D8897),
          ),
        ),
      ],
    );
  }
}
