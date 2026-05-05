import 'package:flutter/material.dart';
import '../services/api_service.dart';
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

  void _submitEvaluation(int totalQuestions) async {
    if (ratings.length < totalQuestions) {
      _showError('Please answer all questions');
      return;
    }

    final feedback = feedbackController.text.trim();
    if (feedback.length < 10) {
      _showError('Feedback must be at least 10 characters');
      return;
    }

    if (feedback.length > 1000) {
      _showError('Feedback cannot exceed 1000 characters');
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      await ApiService.submitEvaluation(
        teacherId: widget.teacher['id'],
        ratings: ratings,
        feedback: feedback,
      );

      if (mounted) {
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
      _showError(errorMessage!);
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 1.5),
              ),
              child: const Icon(
                Icons.school,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.teacher['first_name']} ${widget.teacher['last_name']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
                  const Text('Error loading questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFAF5FF), Color(0xFFF3E8FF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9D5FF), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.teacher['first_name'][0]}${widget.teacher['last_name'][0]}'.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.teacher['first_name']} ${widget.teacher['last_name']}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.teacher['department'],
                              style: const TextStyle(fontSize: 13, color: Color(0xFF6B21A8), fontWeight: FontWeight.w500),
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
                        Text('Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                        Text('${ratings.length}/${questions.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: questions.isEmpty ? 0 : ratings.length / questions.length,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ratings.length == questions.length ? Colors.green : const Color(0xFF7C3AED),
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
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rate each question using stars, then provide detailed constructive feedback.',
                          style: TextStyle(fontSize: 13, color: Colors.amber.shade900, height: 1.4),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 1),
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
                                    gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)]),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                                  ),
                                  child: Center(
                                    child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(questionText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
                                  color: currentRating == 0 ? Colors.grey[500] : const Color(0xFF7C3AED),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Additional Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Share constructive feedback (10-1000 characters)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(color: Color(0xFF7C3AED), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
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
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(errorMessage!, style: TextStyle(color: Colors.red[700], fontSize: 13)),
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

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
