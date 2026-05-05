import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../utils/evaluation_tracker.dart';
import '../widgets/star_rating_widget.dart';
import 'success_screen.dart';

class EvaluationScreen extends StatefulWidget {
  final Map<String, dynamic> teacher;

  const EvaluationScreen({Key? key, required this.teacher}) : super(key: key);

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  late Future<List<dynamic>> _questionsFuture;
  Map<String, int> ratings = {};
  final feedbackController = TextEditingController();
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _questionsFuture = ApiService.getQuestions();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  /// Build avatar with initials
  Widget _buildInitialsAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: Center(
        child: Text(
          '${widget.teacher['first_name'][0]}${widget.teacher['last_name'][0]}'.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  /// Convert base64 string to Image widget
  Widget _buildImageFromBase64(String base64String) {
    try {
      // Extract base64 data from data URL format: "data:image/jpeg;base64,..."
      String base64Data = base64String;
      if (base64String.contains(',')) {
        base64Data = base64String.split(',').last;
      }
      
      final bytes = base64Decode(base64Data);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildInitialsAvatar();
        },
      );
    } catch (e) {
      debugPrint('Error loading base64 image: $e');
      return _buildInitialsAvatar();
    }
  }

  void _submitEvaluation(int totalQuestions) async {
    if (ratings.length < totalQuestions) {
      _showError('Please answer all questions', isError: true);
      return;
    }

    final feedback = feedbackController.text.trim();
    if (feedback.length < 10) {
      _showError('Feedback must be at least 10 characters', isError: true);
      return;
    }

    if (feedback.length > 1000) {
      _showError('Feedback cannot exceed 1000 characters', isError: true);
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      // Wait for evaluation to be submitted and confirmed
      final result = await ApiService.submitEvaluation(
        teacherId: widget.teacher['id'],
        answers: ratings,
        feedback: feedback,
      );
      
      // Only proceed if we got a successful response
      if (result == null) {
        throw Exception('Failed to submit evaluation');
      }

      // Mark teacher as evaluated
      await EvaluationTracker.markAsEvaluated(widget.teacher['id'].toString());

      if (mounted) {
        // Small delay to ensure backend has saved data
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Navigate to success screen (rating modal will show on back press)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(teacher: widget.teacher),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      _showError(errorMessage!, isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isError 
            ? Colors.red.shade600
            : Colors.amber.shade600,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.teacher['first_name']} ${widget.teacher['last_name']}'),
        backgroundColor: const Color(0xFF0f172a),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Error loading questions'),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() => _questionsFuture = ApiService.getQuestions()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          final questions = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teacher Info Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2d3748),
                    border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: widget.teacher['picture'] != null && widget.teacher['picture'].toString().isNotEmpty
                              ? Image.network(
                                  widget.teacher['picture'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('Picture load error: $error');
                                    return _buildInitialsAvatar();
                                  },
                                )
                              : _buildInitialsAvatar(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.teacher['first_name']} ${widget.teacher['last_name']}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.teacher['department'],
                              style: const TextStyle(fontSize: 13, color: Color(0xFF667eea), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Progress Indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[300])),
                        Text('${ratings.length}/${questions.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF667eea))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: questions.isEmpty ? 0 : ratings.length / questions.length,
                        minHeight: 8,
                        backgroundColor: const Color(0xFF4a5568),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ratings.length == questions.length ? Colors.green : const Color(0xFF667eea),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF667eea)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rate each question using stars, then provide detailed constructive feedback.',
                          style: TextStyle(fontSize: 13, color: Colors.grey[300], height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Rating Questions
                ...questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  final questionId = question['id'] as String;
                  final questionText = question['question_text'] as String;
                  final currentRating = ratings[questionId] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d3748),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF667eea).withOpacity(0.2), width: 1),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 1),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                                  ),
                                  child: Center(
                                    child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(questionText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            StarRatingWidget(
                              rating: currentRating,
                              onRatingChanged: (value) {
                                setState(() {
                                  ratings[questionId] = value;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                currentRating == 0 ? 'Click to rate' : ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent'][currentRating - 1],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: currentRating == 0 ? Colors.grey[500] : const Color(0xFF667eea),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),

                // Feedback Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2d3748),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF667eea).withOpacity(0.2), width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Additional Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text('Share constructive feedback (10-1000 characters)', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                      const SizedBox(height: 12),
                      TextField(
                        controller: feedbackController,
                        maxLines: 5,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          hintText: 'Share your feedback...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF4a5568), width: 1.5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1a202c),
                          counterText: '${feedbackController.text.length}/1000',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Error Message
                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[900]!.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[400]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[400]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(errorMessage!, style: TextStyle(color: Colors.red[300], fontSize: 13)),
                        ),
                      ],
                    ),
                  ),

                if (errorMessage != null) const SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : () => _submitEvaluation(questions.length),
                    child: isSubmitting
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Submit Evaluation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          );
        },
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            // Reload Button
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {
                _questionsFuture = ApiService.getQuestions();
              }),
            ),
            // Home Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF667eea),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}