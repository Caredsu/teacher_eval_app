import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/teacher_card.dart';
import '../widgets/skeleton_loader.dart';
import '../utils/evaluation_tracker.dart';
import 'evaluation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futureTeachers;
  late Future<List<dynamic>> futureDepartments;
  String selectedDept = 'All';
  String searchQuery = '';
  bool evaluationsOpen = true;
  Set<String> evaluatedTeacherIds = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize with dummy futures (will be replaced when evaluations open)
    futureTeachers = Future.value([]);
    futureDepartments = Future.value([]);
    
    // Load evaluated teachers
    _loadEvaluatedTeachers();
    
    // Check if evaluations are open FIRST before loading teachers
    _checkEvaluationStatusAndLoadTeachers();
  }

  Future<void> _loadEvaluatedTeachers() async {
    try {
      final evaluated = await EvaluationTracker.getEvaluatedTeacherIds();
      setState(() {
        evaluatedTeacherIds = evaluated.toSet();
      });
    } catch (e) {
      debugPrint('Error loading evaluated teachers: $e');
    }
  }
  
  Future<void> _checkEvaluationStatusAndLoadTeachers() async {
    try {
      final statusData = await ApiService.getTeacherStatus();
      final isOpen = statusData['is_evaluations_open'] as bool? ?? false;
      
      setState(() {
        evaluationsOpen = isOpen;
      });
      
      // Only load teachers and departments if evaluations are open
      if (isOpen) {
        futureTeachers = ApiService.getTeachers();
        futureDepartments = ApiService.getDepartments();
      }
      // If closed, leave futureTeachers as empty Future<List<dynamic>>
    } catch (e) {
      debugPrint('Error checking evaluation status: $e');
      // On error, assume open and load teachers
      setState(() {
        evaluationsOpen = true;
      });
      futureTeachers = ApiService.getTeachers();
      futureDepartments = ApiService.getDepartments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/fbc_logo.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text('Teacher Evaluation System'),
          ],
        ),
        backgroundColor: const Color(0xFF0f172a),
      ),
      body: !evaluationsOpen
          ? SizedBox.expand(
              child: Container(
                color: const Color(0xFF1a202c),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: Color(0xFF667eea),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Evaluations Closed',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Teacher evaluations are currently closed.\nPlease try again later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9ca3af),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          // Reload the page
                          setState(() {
                            _checkEvaluationStatusAndLoadTeachers();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Reload',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              children: [
                // Search Box
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search teacher name...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF667eea)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2d3748),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),

                // Department Filter Pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FutureBuilder<List<dynamic>>(
                    future: futureDepartments,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 40,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF667eea),
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const SizedBox(height: 0);
                      }

                      final departments =
                          snapshot.data ?? [{'code': 'All', 'name': 'All'}];

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: selectedDept == 'All',
                              selectedColor: const Color(0xFF667eea),
                              backgroundColor: const Color(0xFF4a5568),
                              labelStyle: TextStyle(
                                color: selectedDept == 'All' ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  selectedDept = 'All';
                                });
                              },
                            ),
                            ...departments.map((dept) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: FilterChip(
                                  label: Text(dept['code']),
                                  selected: selectedDept == dept['code'],
                                  selectedColor: const Color(0xFF667eea),
                                  backgroundColor: const Color(0xFF4a5568),
                                  labelStyle: TextStyle(
                                    color: selectedDept == dept['code'] ? Colors.white : Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedDept = dept['code'];
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Teachers List with Cards
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: futureTeachers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TeacherCardSkeleton();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 64, color: Colors.red[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading teachers',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.red[300]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF9ca3af)),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    futureTeachers = ApiService.getTeachers();
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline,
                                  size: 64, color: const Color(0xFF4a5568)),
                              const SizedBox(height: 16),
                              Text(
                                'No teachers found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      List<dynamic> teachers = snapshot.data!;

                      // Filter by department
                      if (selectedDept != 'All') {
                        teachers = teachers
                            .where((t) => t['department'] == selectedDept)
                            .toList();
                      }

                      // Filter by search query
                      if (searchQuery.isNotEmpty) {
                        teachers = teachers
                            .where((t) =>
                                '${t['first_name']} ${t['last_name']}'
                                    .toLowerCase()
                                    .contains(searchQuery))
                            .toList();
                      }

                      if (teachers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No teachers match your search',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: teachers.length,
                        itemBuilder: (context, index) {
                          final teacher = teachers[index];
                          final isEvaluated = evaluatedTeacherIds.contains(teacher['id'].toString());

                          return TeacherCard(
                            index: index,
                            teacher: teacher,
                            isEvaluated: isEvaluated,
                            onTap: () {
                              if (!evaluationsOpen) {
                                // Evaluations are closed, don't navigate
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EvaluationScreen(teacher: teacher),
                                ),
                              ).then((_) {
                                // Reload evaluated teachers when returning from evaluation
                                _loadEvaluatedTeachers();
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF0f172a),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF667eea).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
            ),
            // Reload Button
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
              onPressed: () {
                setState(() {
                  futureTeachers = ApiService.getTeachers();
                  futureDepartments = ApiService.getDepartments();
                  _loadEvaluatedTeachers();
                });
              },
              tooltip: 'Reload',
            ),
            // Home Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF667eea),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 24),
                onPressed: () {
                  // Already on home
                },
                tooltip: 'Home',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
