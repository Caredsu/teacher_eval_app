import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonLoader({
    Key? key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.2,
                _animation.value,
                _animation.value + 0.2
              ],
              colors: [
                const Color(0xFF3a4556),
                const Color(0xFF4a5b70),
                const Color(0xFF3a4556),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TeacherCardSkeleton extends StatelessWidget {
  final int count;

  const TeacherCardSkeleton({Key? key, this.count = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF2d3748),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SkeletonLoader(
                  width: 60,
                  height: 60,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        width: double.infinity,
                        height: 16,
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 8),
                      SkeletonLoader(
                        width: 120,
                        height: 12,
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SkeletonLoader(
                  width: 20,
                  height: 20,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
