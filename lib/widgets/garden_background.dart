import 'dart:math';
import 'package:flutter/material.dart';

class GardenBackground extends StatelessWidget {
  const GardenBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GardenPainter(),
      child: Container(),
    );
  }
}

class _GardenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sky gradient (top to middle)
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        const Color(0xFF87CEEB), // Sky blue
        const Color(0xFFB8E6F5), // Light blue
        const Color(0xFFFFE5E5), // Very light pink
      ],
    );

    final skyRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.6);
    canvas.drawRect(
      skyRect,
      Paint()..shader = skyGradient.createShader(skyRect),
    );

    // Ground gradient (middle to bottom)
    final groundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF90C695), // Light sage green
        const Color(0xFF6B9B6E), // Medium green
        const Color(0xFF5A8A5D), // Darker green
      ],
    );

    final groundRect =
        Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45);

    // Create wavy ground line
    final groundPath = Path();
    groundPath.moveTo(-10, size.height * 0.55);

    // Add gentle waves
    for (double x = -10; x <= size.width + 10; x += 20) {
      final y = size.height * 0.55 + sin(x / 30) * 5;
      groundPath.lineTo(x, y);
    }

    groundPath.lineTo(size.width + 10, size.height);
    groundPath.lineTo(-10, size.height);
    groundPath.close();

    canvas.drawPath(
      groundPath,
      Paint()..shader = groundGradient.createShader(groundRect),
    );

    // Draw clouds
    _drawClouds(canvas, size);

    // Draw butterflies
    _drawButterflies(canvas, size);

    // Draw decorative flowers in foreground
    _drawBackgroundFlowers(canvas, size);
  }

  void _drawClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    // Cloud 1
    _drawCloud(
        canvas, Offset(size.width * 0.2, size.height * 0.15), 60, cloudPaint);

    // Cloud 2
    _drawCloud(
        canvas, Offset(size.width * 0.7, size.height * 0.25), 50, cloudPaint);

    // Cloud 3
    _drawCloud(
        canvas, Offset(size.width * 0.5, size.height * 0.1), 45, cloudPaint);
  }

  void _drawCloud(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(
        center.translate(-radius * 0.6, radius * 0.2), radius * 0.8, paint);
    canvas.drawCircle(
        center.translate(radius * 0.6, radius * 0.2), radius * 0.8, paint);
    canvas.drawCircle(center.translate(0, radius * 0.5), radius * 0.7, paint);
  }

  void _drawBackgroundFlowers(Canvas canvas, Size size) {
    final random = Random(123); // Fixed seed

    for (int i = 0; i < 12; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height * 0.6 + random.nextDouble() * size.height * 0.3;
      final flowerSize = 10 + random.nextDouble() * 15;

      final colors = [
        const Color(0xFFFFC0CB), // Pink
        const Color(0xFFFFB6C1), // Light pink
        const Color(0xFFFF69B4), // Hot pink
        const Color(0xFFFFDAB9), // Peach
        const Color(0xFFFFA07A), // Light salmon
      ];

      final color = colors[random.nextInt(colors.length)];

      _drawSimpleFlower(canvas, Offset(x, y), flowerSize, color);
    }
  }

  void _drawSimpleFlower(
      Canvas canvas, Offset center, double size, Color color) {
    final petalPaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Draw 5 petals
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5);
      final petalCenter = center +
          Offset(
            cos(angle) * size * 0.5,
            sin(angle) * size * 0.5,
          );
      canvas.drawCircle(petalCenter, size * 0.4, petalPaint);
    }

    // Draw center
    canvas.drawCircle(center, size * 0.3, centerPaint);
  }

  void _drawButterflies(Canvas canvas, Size size) {
    final random = Random(456);

    for (int i = 0; i < 3; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height * 0.2 + random.nextDouble() * size.height * 0.3;
      final butterflySize = 15 + random.nextDouble() * 10;

      _drawButterfly(canvas, Offset(x, y), butterflySize);
    }
  }

  void _drawButterfly(Canvas canvas, Offset center, double size) {
    final wingPaint = Paint()
      ..color = const Color(0xFFFF69B4).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final bodyPaint = Paint()
      ..color = const Color(0xFF8B4513).withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Left wings
    final leftTopWing = Path();
    leftTopWing.moveTo(center.dx, center.dy);
    leftTopWing.quadraticBezierTo(
      center.dx - size * 0.8,
      center.dy - size * 0.5,
      center.dx - size * 0.5,
      center.dy - size,
    );
    leftTopWing.quadraticBezierTo(
      center.dx - size * 0.3,
      center.dy - size * 0.5,
      center.dx,
      center.dy,
    );
    canvas.drawPath(leftTopWing, wingPaint);

    final leftBottomWing = Path();
    leftBottomWing.moveTo(center.dx, center.dy);
    leftBottomWing.quadraticBezierTo(
      center.dx - size * 0.7,
      center.dy + size * 0.3,
      center.dx - size * 0.4,
      center.dy + size * 0.8,
    );
    leftBottomWing.quadraticBezierTo(
      center.dx - size * 0.2,
      center.dy + size * 0.4,
      center.dx,
      center.dy,
    );
    canvas.drawPath(leftBottomWing, wingPaint);

    // Right wings (mirror)
    final rightTopWing = Path();
    rightTopWing.moveTo(center.dx, center.dy);
    rightTopWing.quadraticBezierTo(
      center.dx + size * 0.8,
      center.dy - size * 0.5,
      center.dx + size * 0.5,
      center.dy - size,
    );
    rightTopWing.quadraticBezierTo(
      center.dx + size * 0.3,
      center.dy - size * 0.5,
      center.dx,
      center.dy,
    );
    canvas.drawPath(rightTopWing, wingPaint);

    final rightBottomWing = Path();
    rightBottomWing.moveTo(center.dx, center.dy);
    rightBottomWing.quadraticBezierTo(
      center.dx + size * 0.7,
      center.dy + size * 0.3,
      center.dx + size * 0.4,
      center.dy + size * 0.8,
    );
    rightBottomWing.quadraticBezierTo(
      center.dx + size * 0.2,
      center.dy + size * 0.4,
      center.dx,
      center.dy,
    );
    canvas.drawPath(rightBottomWing, wingPaint);

    // Body
    canvas.drawLine(
      center.translate(0, -size * 0.3),
      center.translate(0, size * 0.5),
      bodyPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
