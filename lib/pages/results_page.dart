import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      {'name': 'John Doe', 'rollNo': '001', 'status': 'Present', 'confidence': 98},
      {'name': 'Jane Smith', 'rollNo': '002', 'status': 'Present', 'confidence': 96},
      {'name': 'Mike Johnson', 'rollNo': '003', 'status': 'Absent', 'confidence': 0},
      {'name': 'Sarah Williams', 'rollNo': '004', 'status': 'Present', 'confidence': 99},
      {'name': 'Tom Brown', 'rollNo': '005', 'status': 'Present', 'confidence': 94},
    ];

    final presentCount = students.where((s) => s['status'] == 'Present').length;
    final totalCount = students.length;
    final percentage = ((presentCount / totalCount) * 100).round();

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
          'Attendance Results',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F9FB),
        child: Column(
          children: [
          // Summary Card with enhanced design
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1A4FB8),
                  Color(0xFF00BFFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A4FB8).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.analytics,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Session Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      icon: Icons.check_circle_outline,
                      label: 'Present',
                      value: '$presentCount',
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _SummaryItem(
                      icon: Icons.cancel_outlined,
                      label: 'Absent',
                      value: '${totalCount - presentCount}',
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _SummaryItem(
                      icon: Icons.show_chart,
                      label: 'Rate',
                      value: '$percentage%',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Student Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3544),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A4FB8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalCount',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A4FB8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Students List with enhanced cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final isPresent = student['status'] == 'Present';
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isPresent 
                        ? const Color(0xFF33CC66).withOpacity(0.3)
                        : const Color(0xFFE84545).withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Avatar with enhanced styling
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isPresent
                                  ? [
                                      const Color(0xFF33CC66).withOpacity(0.2),
                                      const Color(0xFF33CC66).withOpacity(0.1),
                                    ]
                                  : [
                                      const Color(0xFFE84545).withOpacity(0.2),
                                      const Color(0xFFE84545).withOpacity(0.1),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isPresent ? Icons.person : Icons.person_off,
                            color: isPresent
                                ? const Color(0xFF33CC66)
                                : const Color(0xFFE84545),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Student Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2B3544),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.badge,
                                    size: 14,
                                    color: Color(0xFF7D8897),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Roll No: ${student['rollNo']}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF7D8897),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Status Badge
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isPresent
                                      ? [
                                          const Color(0xFF33CC66),
                                          const Color(0xFF2DB55D),
                                        ]
                                      : [
                                          const Color(0xFFE84545),
                                          const Color(0xFFD63939),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isPresent
                                            ? const Color(0xFF33CC66)
                                            : const Color(0xFFE84545))
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                student['status'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            if (isPresent) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    size: 14,
                                    color: Color(0xFF33CC66),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${student['confidence']}% match',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF33CC66),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Enhanced Action Buttons
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 20),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1A4FB8),
                        side: const BorderSide(color: Color(0xFF1A4FB8), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                        context.go('/');
                      },
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4FB8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
