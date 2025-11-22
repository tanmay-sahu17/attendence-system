import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late List<Map<String, dynamic>> students;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    students = [
      {'name': 'John Doe', 'rollNo': '001', 'status': 'Present', 'confidence': 98},
      {'name': 'Jane Smith', 'rollNo': '002', 'status': 'Present', 'confidence': 96},
      {'name': 'Mike Johnson', 'rollNo': '003', 'status': 'Absent', 'confidence': 0},
      {'name': 'Sarah Williams', 'rollNo': '004', 'status': 'Present', 'confidence': 99},
      {'name': 'Tom Brown', 'rollNo': '005', 'status': 'Present', 'confidence': 94},
    ];
  }

  void _toggleAttendance(int index) {
    setState(() {
      final currentStatus = students[index]['status'];
      students[index]['status'] = currentStatus == 'Present' ? 'Absent' : 'Present';
    });
  }

  List<Map<String, dynamic>> _getFilteredStudents() {
    if (_searchQuery.isEmpty) {
      return students;
    }
    return students.where((student) {
      final name = student['name'].toString().toLowerCase();
      final rollNo = student['rollNo'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || rollNo.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _getFilteredStudents();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F),
        elevation: 0,
        title: const Text(
          'Attendance Results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lecture #5',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3544),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9C4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${filteredStudents.length} students',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search Box
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search student...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Section
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            _TableHeaderCell('Roll No', width: 80),
                            _TableHeaderCell('Name', flex: 2),
                            _TableHeaderCell('Status', width: 100),
                            _TableHeaderCell('Confidence', width: 100),
                          ],
                        ),
                      ),
                      // Table Rows
                      ...filteredStudents.asMap().entries.map((entry) {
                        final index = students.indexOf(entry.value);
                        final student = entry.value;
                        final isPresent = student['status'] == 'Present';
                        final rowIndex = entry.key;
                        
                        return InkWell(
                          onTap: () => _toggleAttendance(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: rowIndex % 2 == 0 ? Colors.white : Colors.grey[50],
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                _TableCell(student['rollNo'], width: 80),
                                _TableCell(student['name'], flex: 2),
                                _StatusCell(
                                  student['status'],
                                  width: 100,
                                  onTap: () => _toggleAttendance(index),
                                ),
                                _TableCell(
                                  isPresent ? '${student['confidence']}%' : '-',
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0A192F),
                        side: BorderSide(color: Colors.grey[400]!),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A192F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
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

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final double? width;
  final int? flex;

  const _TableHeaderCell(this.text, {this.width, this.flex});

  @override
  Widget build(BuildContext context) {
    Widget cell = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2B3544),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: cell);
    } else if (flex != null) {
      return Expanded(flex: flex!, child: cell);
    }
    return cell;
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final double? width;
  final int? flex;

  const _TableCell(this.text, {this.width, this.flex});

  @override
  Widget build(BuildContext context) {
    Widget cell = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF2B3544),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: cell);
    } else if (flex != null) {
      return Expanded(flex: flex!, child: cell);
    }
    return cell;
  }
}

class _StatusCell extends StatelessWidget {
  final String status;
  final double? width;
  final VoidCallback onTap;

  const _StatusCell(this.status, {this.width, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color bgColor;
    
    switch (status) {
      case 'Present':
        statusColor = const Color(0xFF4CAF50);
        bgColor = const Color(0xFFE8F5E9);
        break;
      case 'Absent':
        statusColor = const Color(0xFFE84545);
        bgColor = const Color(0xFFFFEBEE);
        break;
      default:
        statusColor = Colors.grey[600]!;
        bgColor = Colors.grey[200]!;
    }

    Widget cell = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: cell);
    }
    return cell;
  }
}
