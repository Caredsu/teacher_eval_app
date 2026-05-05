import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final int maxStars;

  const StarRatingWidget({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
    this.maxStars = 5,
  }) : super(key: key);

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  int? hoverRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxStars, (index) {
        final isFilled = widget.rating > index;
        final isHovered = hoverRating != null && hoverRating! > index;

        return MouseRegion(
          onEnter: (_) => setState(() => hoverRating = index + 1),
          onExit: (_) => setState(() => hoverRating = null),
          child: GestureDetector(
            onTap: () => widget.onRatingChanged(index + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: AnimatedScale(
                scale: (isFilled || isHovered) ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isFilled ? Icons.star : Icons.star_border,
                    key: ValueKey(isFilled),
                    size: 44,
                    color: (isFilled || isHovered)
                        ? Colors.amber.shade400
                        : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
