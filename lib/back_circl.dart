import 'package:flutter/material.dart';

class PartOfBack extends StatelessWidget {
  final Color begin;
  final Color end;
  final double radius;
  final bool isTop;
  const PartOfBack({
    super.key,
    required this.begin,
    required this.end,
    required this.radius,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isTop ? -radius : null,
      left: isTop ? -radius : null,
      bottom: isTop ? null : -radius,
      right: isTop ? null : -radius,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [begin, end],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
