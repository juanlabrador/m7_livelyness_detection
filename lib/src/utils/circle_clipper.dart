import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper({required this.radius});
  final double radius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
