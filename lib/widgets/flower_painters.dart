import 'package:flutter/material.dart';
import '../models/flower_type.dart';

class PetalPainter extends CustomPainter {
  final Color color;
  final PetalShape shape;

  PetalPainter({required this.color, required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Add subtle shadow/depth
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();

    switch (shape) {
      case PetalShape.oblong:
        // Daisy petal
        path.moveTo(size.width * 0.5, size.height); // Base
        path.quadraticBezierTo(
            0, size.height * 0.6, size.width * 0.2, size.height * 0.2);
        path.quadraticBezierTo(
            size.width * 0.5, 0, size.width * 0.8, size.height * 0.2);
        path.quadraticBezierTo(
            size.width, size.height * 0.6, size.width * 0.5, size.height);
        break;

      case PetalShape.rounded:
        // Rose petal - heart-ish/round shape
        path.moveTo(size.width * 0.5, size.height); // Base
        path.cubicTo(-size.width * 0.2, size.height * 0.5, 0, 0,
            size.width * 0.5, size.height * 0.1);
        path.cubicTo(size.width, 0, size.width * 1.2, size.height * 0.5,
            size.width * 0.5, size.height);
        break;

      case PetalShape.pointed:
        // Sunflower petal - pointy
        path.moveTo(size.width * 0.5, size.height); // Base
        path.quadraticBezierTo(
            0, size.height * 0.5, size.width * 0.5, 0); // Tip
        path.quadraticBezierTo(
            size.width, size.height * 0.5, size.width * 0.5, size.height);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, shadowPaint);

    // Add detail line in middle
    final detailPath = Path();
    detailPath.moveTo(size.width * 0.5, size.height * 0.9);
    detailPath.lineTo(size.width * 0.5, size.height * 0.4);

    canvas.drawPath(
        detailPath,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant PetalPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shape != shape;
  }
}

class FlowerCenterPainter extends CustomPainter {
  final Color color;
  final double radius;

  FlowerCenterPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // Add texture details (dots)
    final dotPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Draw some random dots for texture
    // Deterministic pattern for performance/consistency
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
          center + Offset((i * 4) - 8.0, (i * 3) - 6.0), 2, dotPaint);
      canvas.drawCircle(
          center + Offset(-(i * 3) + 6.0, (i * 4) - 8.0), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
