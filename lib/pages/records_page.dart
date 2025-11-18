import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/top_bar.dart';
import '../components/bottom_nav.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

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
              'Attendance Records',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B3544),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'View past attendance sessions',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7D8897),
              ),
            ),
            const SizedBox(height: 24),
            ..._buildRecordCards(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  List<Widget> _buildRecordCards() {
    final records = [
      {
        'date': 'Today, 10:30 AM',
        'students': 42,
        'total': 45,
        'percentage': 93,
      },
      {
        'date': 'Yesterday, 10:30 AM',
        'students': 45,
        'total': 45,
        'percentage': 100,
      },
      {
        'date': 'Dec 18, 2024',
        'students': 40,
        'total': 45,
        'percentage': 89,
      },
    ];

    return records.map((record) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      record['date'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3544),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28A745).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${record['percentage']}%',
                        style: const TextStyle(
                          color: Color(0xFF28A745),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: Color(0xFF7D8897),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${record['students']}/${record['total']} students present',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7D8897),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
