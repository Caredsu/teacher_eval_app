import 'package:flutter/material.dart';
import '../models/teacher.dart';
import '../services/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    futureTeachers = ApiService.getTeachers();
    futureDepartments = ApiService.getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Evaluation'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search teacher name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Department Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<dynamic>>(
              future: futureDepartments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
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
                            onSelected: (selected) {
                              setState(() {
                                selectedDept = dept['code'];
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Teachers List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureTeachers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading teachers',
                          style: TextStyle(
                              fontSize: 16, color: Colors.red[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
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
                  return const Center(
                    child: Text('No teachers found'),
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
                          '${t['firstname']} ${t['lastname']}'
                              .toLowerCase()
                              .contains(searchQuery))
                      .toList();
                }

                if (teachers.isEmpty) {
                  return const Center(
                    child: Text('No teachers match your search'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF1976D2),
                          child: Text(
                            '${teacher['first_name'][0]}${teacher['last_name'][0]}'
                                .toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          '${teacher['first_name']} ${teacher['last_name']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          teacher['department'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EvaluationScreen(teacher: teacher),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
