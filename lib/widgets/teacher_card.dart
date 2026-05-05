import 'package:flutter/material.dart';
import 'dart:convert';

class TeacherCard extends StatefulWidget {
  final Map<String, dynamic> teacher;
  final VoidCallback onTap;
  final int index;
  final bool isEvaluated;

  const TeacherCard({
    Key? key,
    required this.teacher,
    required this.onTap,
    this.index = 0,
    this.isEvaluated = false,
  }) : super(key: key);

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get avatar gradient colors based on teacher initials
  List<Color> _getAvatarGradient(String initials) {
    final hash = initials.codeUnitAt(0) % 5;
    
    const gradients = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFF10b981), Color(0xFF6366f1)],
      [Color(0xFFf97316), Color(0xFFef4444)],
      [Color(0xFF06b6d4), Color(0xFF3b82f6)],
      [Color(0xFF8b5cf6), Color(0xFFec4899)],
    ];
    
    return gradients[hash];
  }

  /// Convert base64 string to Image widget
  Widget _buildImageFromBase64(String base64String, List<Color> fallbackGradient, String initials) {
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
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: fallbackGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Error loading base64 image: $e');
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: fallbackGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.teacher['first_name'] ?? 'Unknown';
    final lastName = widget.teacher['last_name'] ?? 'User';
    final department = widget.teacher['department'] ?? 'N/A';
    final initials = '${firstName[0]}${lastName[0]}'.toUpperCase();
    final avatarGradient = _getAvatarGradient(initials);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: const Color(0xFF667eea).withOpacity(0.1),
            highlightColor: const Color(0xFF667eea).withOpacity(0.05),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF2d3748),
                border: Border.all(
                  color: widget.isEvaluated
                      ? Colors.green.withOpacity(0.4)
                      : const Color(0xFF667eea).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar with Stack for checkmark badge
                    Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: widget.teacher['picture'] != null && widget.teacher['picture'].toString().isNotEmpty
                                ? Image.network(
                                    widget.teacher['picture'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: avatarGradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            initials,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: avatarGradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        // Evaluated checkmark badge
                        if (widget.isEvaluated)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(
                                  color: const Color(0xFF1a202c),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Teacher Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '$firstName $lastName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.isEvaluated) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.5),
                                    ),
                                  ),
                                  child: const Text(
                                    'Evaluated',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9D5FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              department,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B21A8),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.blue.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
