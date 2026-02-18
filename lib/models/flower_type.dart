import 'package:flutter/material.dart';

enum FlowerType {
  daisy(
    id: 'daisy',
    name: 'Margarida',
    centerColor: Color(0xFFFFD700), // Gold
    petalColor: Colors.white,
    stemColor: Color(0xFF6B8C42),
    petalShape: PetalShape.oblong,
  ),
  rose(
    id: 'rose',
    name: 'Rosa',
    centerColor: Color(0xFF8B0000), // Dark red center
    petalColor: Color(0xFFFF4040), // Red/Pink
    stemColor: Color(0xFF4A6B32),
    petalShape: PetalShape.rounded,
  ),
  sunflower(
    id: 'sunflower',
    name: 'Girassol',
    centerColor: Color(0xFF4B3621), // Dark Brown
    petalColor: Color(0xFFFFD700), // Yellow
    stemColor: Color(0xFF556B2F),
    petalShape: PetalShape.pointed,
  );

  final String id;
  final String name;
  final Color centerColor;
  final Color petalColor;
  final Color stemColor;
  final PetalShape petalShape;

  const FlowerType({
    required this.id,
    required this.name,
    required this.centerColor,
    required this.petalColor,
    required this.stemColor,
    required this.petalShape,
  });
}

enum PetalShape {
  oblong, // Daisy
  rounded, // Rose
  pointed, // Sunflower
}
