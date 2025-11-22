import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowRecordsPage extends StatefulWidget {
  const ShowRecordsPage({super.key});

  @override
  State<ShowRecordsPage> createState() => _ShowRecordsPageState();
}

class _ShowRecordsPageState extends State<ShowRecordsPage> {
  String _searchQuery = '';
  String _filterStatus = 'All';
  String _selectedLecture = 'All Lectures';
  String _selectedSemester = 'All Semesters';
  String _selectedSection = 'All Sections';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _getFilteredStudents();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F),
        elevation: 0,
        title: const Text(
          'Student Records',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
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
                  const Text(
                    'Student Records',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B3544),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Filters Row
                  Row(
                    children: [
                      // Semester Selector
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.school,
                                size: 16,
                                color: Color(0xFF0A192F),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedSemester,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                                  items: _getSemesters().map((semester) {
                                    return DropdownMenuItem<String>(
                                      value: semester,
                                      child: Text(
                                        semester,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSemester = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Section Selector
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.group,
                                size: 16,
                                color: Color(0xFF0A192F),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedSection,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                                  items: _getSections().map((section) {
                                    return DropdownMenuItem<String>(
                                      value: section,
                                      child: Text(
                                        section,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSection = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Date Selector
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F8),
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFF0A192F),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Select Date',
                            style: TextStyle(
                              fontSize: 13,
                              color: _selectedDate != null ? const Color(0xFF2B3544) : Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          if (_selectedDate != null)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedDate = null;
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  // Lecture Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8),
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Color(0xFF0A192F),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Lecture:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B3544),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedLecture,
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, size: 20),
                            items: _getLectures().map((lecture) {
                              return DropdownMenuItem<String>(
                                value: lecture,
                                child: Text(
                                  lecture,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLecture = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  // Search Bar
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
                  const SizedBox(height: 12),
                  // Filter Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterPill(
                          label: 'All',
                          count: _getAllStudents().length,
                          isSelected: _filterStatus == 'All',
                          onTap: () => setState(() => _filterStatus = 'All'),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: 'Present',
                          count: _getAllStudents().where((s) => s['status'] == 'Present').length,
                          isSelected: _filterStatus == 'Present',
                          onTap: () => setState(() => _filterStatus = 'Present'),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: 'Absent',
                          count: _getAllStudents().where((s) => s['status'] == 'Absent').length,
                          isSelected: _filterStatus == 'Absent',
                          onTap: () => setState(() => _filterStatus = 'Absent'),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: 'Late',
                          count: _getAllStudents().where((s) => s['status'] == 'Late').length,
                          isSelected: _filterStatus == 'Late',
                          onTap: () => setState(() => _filterStatus = 'Late'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Table
            Expanded(
              child: filteredStudents.isEmpty
                  ? Center(
                      child: Text(
                        'No students found',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: _buildTable(filteredStudents),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> students) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                _TableHeaderCell('Roll No', width: 100),
                _TableHeaderCell('Name', width: 180),
                _TableHeaderCell('Status', width: 100),
                _TableHeaderCell('Attendance', width: 110),
                _TableHeaderCell('Present', width: 90),
                _TableHeaderCell('Absent', width: 90),
                _TableHeaderCell('Late', width: 90),
              ],
            ),
          ),
          // Data Rows
          ...students.asMap().entries.map((entry) {
            final index = entry.key;
            final student = entry.value;
            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  _TableCell(student['rollNumber'], width: 100),
                  _TableCell(student['name'], width: 180),
                  _StatusCell(student['status'], width: 100),
                  _TableCell('${student['attendance']}%', width: 110),
                  _TableCell('${student['present']}', width: 90),
                  _TableCell('${student['absent']}', width: 90),
                  _TableCell('${student['late']}', width: 90),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredStudents() {
    final students = _getAllStudents();
    
    var filtered = students.where((student) {
      final matchesSearch = student['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student['rollNumber']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _filterStatus == 'All' || 
          student['status'] == _filterStatus;
      
      final matchesLecture = _selectedLecture == 'All Lectures' ||
          student['lastLecture'] == _selectedLecture;
      
      final matchesSemester = _selectedSemester == 'All Semesters' ||
          student['semester'] == _selectedSemester;
      
      final matchesSection = _selectedSection == 'All Sections' ||
          student['section'] == _selectedSection;
      
      final matchesDate = _selectedDate == null ||
          student['date'] == '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      
      return matchesSearch && matchesFilter && matchesLecture && 
             matchesSemester && matchesSection && matchesDate;
    }).toList();
    
    return filtered;
  }

  List<String> _getSemesters() {
    return [
      'All Semesters',
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8',
    ];
  }

  List<String> _getSections() {
    return [
      'All Sections',
      'Section A',
      'Section B',
      'Section C',
      'Section D',
    ];
  }

  List<String> _getLectures() {
    return [
      'All Lectures',
      'Today, 10:30 AM',
      'Yesterday, 10:30 AM',
      'Nov 20, 2024 - 10:30 AM',
      'Nov 19, 2024 - 2:00 PM',
      'Nov 18, 2024 - 10:30 AM',
    ];
  }

  List<Map<String, dynamic>> _getAllStudents() {
    return [
      {
        'name': 'Aarav Sharma',
        'rollNumber': 'CS001',
        'status': 'Present',
        'attendance': 95,
        'totalClasses': 40,
        'present': 38,
        'absent': 2,
        'late': 0,
        'lastLecture': 'Today, 10:30 AM',
        'semester': 'Semester 3',
        'section': 'Section A',
        'date': '22/11/2025',
      },
      {
        'name': 'Priya Patel',
        'rollNumber': 'CS002',
        'status': 'Present',
        'attendance': 92,
        'totalClasses': 40,
        'present': 37,
        'absent': 2,
        'late': 1,
        'lastLecture': 'Today, 10:30 AM',
        'semester': 'Semester 3',
        'section': 'Section A',
        'date': '22/11/2025',
      },
      {
        'name': 'Rahul Kumar',
        'rollNumber': 'CS003',
        'status': 'Absent',
        'attendance': 75,
        'totalClasses': 40,
        'present': 30,
        'absent': 8,
        'late': 2,
        'lastLecture': 'Today, 10:30 AM',
        'semester': 'Semester 3',
        'section': 'Section B',
        'date': '22/11/2025',
      },
      {
        'name': 'Sneha Reddy',
        'rollNumber': 'CS004',
        'status': 'Present',
        'attendance': 98,
        'totalClasses': 40,
        'present': 39,
        'absent': 1,
        'late': 0,
        'lastLecture': 'Yesterday, 10:30 AM',
        'semester': 'Semester 5',
        'section': 'Section A',
        'date': '21/11/2025',
      },
      {
        'name': 'Arjun Singh',
        'rollNumber': 'CS005',
        'status': 'Late',
        'attendance': 88,
        'totalClasses': 40,
        'present': 34,
        'absent': 3,
        'late': 3,
        'lastLecture': 'Yesterday, 10:30 AM',
        'semester': 'Semester 5',
        'section': 'Section B',
        'date': '21/11/2025',
      },
      {
        'name': 'Ananya Gupta',
        'rollNumber': 'CS006',
        'status': 'Present',
        'attendance': 94,
        'totalClasses': 40,
        'present': 37,
        'absent': 2,
        'late': 1,
        'lastLecture': 'Nov 20, 2024 - 10:30 AM',
        'semester': 'Semester 4',
        'section': 'Section C',
        'date': '20/11/2025',
      },
      {
        'name': 'Vikas Verma',
        'rollNumber': 'CS007',
        'status': 'Absent',
        'attendance': 70,
        'totalClasses': 40,
        'present': 28,
        'absent': 10,
        'late': 2,
        'lastLecture': 'Nov 19, 2024 - 2:00 PM',
        'semester': 'Semester 6',
        'section': 'Section A',
        'date': '19/11/2025',
      },
      {
        'name': 'Ishita Joshi',
        'rollNumber': 'CS008',
        'status': 'Present',
        'attendance': 96,
        'totalClasses': 40,
        'present': 38,
        'absent': 1,
        'late': 1,
        'lastLecture': 'Nov 18, 2024 - 10:30 AM',
        'semester': 'Semester 7',
        'section': 'Section D',
        'date': '18/11/2025',
      },
    ];
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A192F) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const _TableHeaderCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final double width;

  const _TableCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF2B3544),
        ),
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  final String status;
  final double width;

  const _StatusCell(this.status, {required this.width});

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
      case 'Late':
        statusColor = const Color(0xFFFFC107);
        bgColor = const Color(0xFFFFF9C4);
        break;
      default:
        statusColor = Colors.grey[600]!;
        bgColor = Colors.grey[200]!;
    }

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
    );
  }
}
