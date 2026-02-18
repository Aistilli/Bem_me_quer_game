import 'dart:math';
import 'package:flutter/material.dart';
import '../models/flower_type.dart';
import 'flower_painters.dart';

class PetalWidget extends StatelessWidget {
  final FlowerType type;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const PetalWidget({
    super.key,
    required this.type,
    this.width = 40,
    this.height = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: PetalPainter(
            color: type.petalColor,
            shape: type.petalShape,
          ),
        ),
      ),
    );
  }
}

class FlowerWidget extends StatefulWidget {
  final FlowerType type;
  final int petalCount;
  final Function(int remaining) onPetalRemoved;
  final bool isInteractive;

  const FlowerWidget({
    super.key,
    required this.type,
    required this.petalCount,
    required this.onPetalRemoved,
    this.isInteractive = true,
  });

  @override
  State<FlowerWidget> createState() => _FlowerWidgetState();
}

class _FlowerWidgetState extends State<FlowerWidget>
    with TickerProviderStateMixin {
  late List<bool> _isAttached;
  // Animation controllers for each petal's fall
  final Map<int, AnimationController> _controllers = {};
  final Map<int, Animation<Offset>> _animations = {};
  final Map<int, Animation<double>> _rotations = {};
  final Map<int, double> _randomOffsetX = {};

  @override
  void initState() {
    super.initState();
    _initializePetals();
  }

  void _initializePetals() {
    _isAttached = List.generate(widget.petalCount, (index) => true);
  }

  @override
  void didUpdateWidget(FlowerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.petalCount != widget.petalCount ||
        oldWidget.type != widget.type) {
      _disposeControllers();
      _initializePetals();
    }
  }

  void _disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
    _rotations.clear();
    _randomOffsetX.clear();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _removePetal(int index) {
    if (!_isAttached[index] || !widget.isInteractive) return;

    // Initialize animation for this specific petal
    final controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Random fall direction
    final random = Random();
    final fallLeft = random.nextBool();
    final xOffset = (fallLeft ? -100.0 : 100.0) + (random.nextDouble() * 50);
    _randomOffsetX[index] = xOffset;

    final animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(xOffset, 500.0), // Fall down and sideways
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInQuad,
    ));

    final rotation = Tween<double>(
      begin: 0,
      end: random.nextDouble() * 2 * pi * (random.nextBool() ? 1 : -1),
    ).animate(controller);

    setState(() {
      _isAttached[index] = false;
      _controllers[index] = controller;
      _animations[index] = animation;
      _rotations[index] = rotation;
    });

    controller.forward().then((_) {
      // Cleanup after animation if needed, but keeping it in state is fine for this scope
    });

    // Notify parent
    int remaining = _isAttached.where((attached) => attached).length;
    widget.onPetalRemoved(remaining);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Limit flower size based on screen
    final flowerRadius = min(size.width, size.height) * 0.35; // slightly larger
    final centerRadius = flowerRadius * 0.25;
    final petalLength = flowerRadius * 0.6;
    final petalWidth = petalLength * 0.5;

    return SizedBox(
      width: flowerRadius * 2,
      height: flowerRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Stem
          Positioned(
            top: flowerRadius,
            child: Container(
              width: 8,
              height: flowerRadius * 1.5,
              decoration: BoxDecoration(
                color: widget.type.stemColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Petals
          ...List.generate(widget.petalCount, (index) {
            final angle = (2 * pi / widget.petalCount) * index;
            // Position petals around the center
            // We want the base of the petal to be at the edge of the center
            final double radius = centerRadius * 0.8;

            final dx = radius * cos(angle);
            final dy = radius * sin(angle);

            return AnimatedBuilder(
              animation: _controllers[index] ?? const AlwaysStoppedAnimation(0),
              builder: (context, child) {
                final isFalling = _controllers.containsKey(index);
                final slide =
                    isFalling ? _animations[index]!.value : Offset.zero;
                final rotation = isFalling ? _rotations[index]!.value : 0.0;
                final opacity = isFalling
                    ? (1.0 - _controllers[index]!.value).clamp(0.0, 1.0)
                    : 1.0;

                return Transform.translate(
                  offset: Offset(dx, dy) + slide,
                  child: Transform.rotate(
                    angle:
                        angle + rotation + (pi / 2), // Rotate to point outwards
                    child: Opacity(
                      opacity: opacity,
                      child: PetalWidget(
                        type: widget.type,
                        width: petalWidth,
                        height: petalLength,
                        onTap: () => _removePetal(index),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Center
          Container(
            width: centerRadius * 2,
            height: centerRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomPaint(
              painter: FlowerCenterPainter(
                color: widget.type.centerColor,
                radius: centerRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
