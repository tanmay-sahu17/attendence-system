import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F9FB), // bg-background from web
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Welcome Section
            const Text(
              'Welcome, Teacher',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B3544), // text-foreground
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ready to track attendance',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7D8897), // text-muted-foreground
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                    child: const Column(
                      children: [
                        Icon(Icons.people, color: Color(0xFF1A4FB8), size: 20),
                        SizedBox(height: 8),
                        Text(
                          '45',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B3544),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Students',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7D8897),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                    child: const Column(
                      children: [
                        Icon(Icons.trending_up, color: Color(0xFF33CC66), size: 20),
                        SizedBox(height: 8),
                        Text(
                          '92%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33CC66),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Avg Rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7D8897),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                    child: const Column(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF00BFFF), size: 20),
                        SizedBox(height: 8),
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B3544),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sessions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7D8897),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action Cards
            _ActionCard(
              icon: Icons.videocam,
              title: 'Record Attendance',
              description: 'Start camera to capture students',
              gradientColors: const [Color(0xFF1A4FB8), Color(0xFF2563EB)],
              onTap: () => context.push('/camera'),
            ),
            
            const SizedBox(height: 16),
            
            _ActionCard(
              icon: Icons.description,
              title: 'View Records',
              description: 'Check attendance history',
              gradientColors: const [Color(0xFF33CC66), Color(0xFF22C55E)],
              onTap: () => context.push('/records'),
            ),
            
            const SizedBox(height: 24),
            
            // AI Info Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1A4FB8).withOpacity(0.1),
                    const Color(0xFF00BFFF).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1A4FB8).withOpacity(0.2),
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF00BFFF),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI-Powered Recognition',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B3544),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Our advanced facial recognition system ensures accurate attendance tracking with 99% accuracy.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7D8897),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7D8897),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}