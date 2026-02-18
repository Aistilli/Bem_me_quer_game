import 'dart:math';
import 'package:flutter/material.dart';

/// Widget que exibe corações subindo na tela com animação
class RisingHeartsWidget extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback? onComplete;

  const RisingHeartsWidget({
    super.key,
    required this.isPlaying,
    this.onComplete,
  });

  @override
  State<RisingHeartsWidget> createState() => _RisingHeartsWidgetState();
}

class _RisingHeartsWidgetState extends State<RisingHeartsWidget>
    with TickerProviderStateMixin {
  final List<_HeartParticle> _hearts = [];
  final Random _random = Random();
  AnimationController? _emissionController;

  @override
  void initState() {
    super.initState();
    if (widget.isPlaying) {
      _startEmission();
    }
  }

  @override
  void didUpdateWidget(RisingHeartsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startEmission();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopEmission();
    }
  }

  void _startEmission() {
    _emissionController?.dispose();
    _emissionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Criar corações continuamente durante a animação
    _emissionController!.addListener(() {
      if (_random.nextDouble() < 0.15) {
        // 15% de chance por frame
        _addHeart();
      }
    });

    _emissionController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _emissionController!.forward();
  }

  void _stopEmission() {
    _emissionController?.stop();
  }

  void _addHeart() {
    final size = MediaQuery.of(context).size;
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500 + _random.nextInt(1000)),
    );

    final startX = _random.nextDouble() * size.width;
    final endX = startX + (_random.nextDouble() - 0.5) * 100;

    final heart = _HeartParticle(
      controller: controller,
      startX: startX,
      endX: endX,
      color: _randomHeartColor(),
      size: 20 + _random.nextDouble() * 20,
      rotation: _random.nextDouble() * pi * 2,
    );

    setState(() {
      _hearts.add(heart);
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _hearts.remove(heart);
        });
        controller.dispose();
      }
    });

    controller.forward();
  }

  Color _randomHeartColor() {
    final colors = [
      Colors.red,
      Colors.pink,
      const Color(0xFFFF69B4), // Hot pink
      const Color(0xFFFF1493), // Deep pink
      const Color(0xFFFFC0CB), // Light pink
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _emissionController?.dispose();
    for (var heart in _hearts) {
      heart.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children:
            _hearts.map((heart) => _AnimatedHeart(particle: heart)).toList(),
      ),
    );
  }
}

class _HeartParticle {
  final AnimationController controller;
  final double startX;
  final double endX;
  final Color color;
  final double size;
  final double rotation;

  _HeartParticle({
    required this.controller,
    required this.startX,
    required this.endX,
    required this.color,
    required this.size,
    required this.rotation,
  });
}

class _AnimatedHeart extends StatelessWidget {
  final _HeartParticle particle;

  const _AnimatedHeart({required this.particle});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: particle.controller,
      builder: (context, child) {
        final progress = particle.controller.value;

        // Movimento de baixo para cima
        final y = size.height - (progress * size.height * 1.2);

        // Movimento horizontal com curva senoidal
        final x = particle.startX +
            (particle.endX - particle.startX) * progress +
            sin(progress * pi * 3) * 30;

        // Fade out no final
        final opacity = progress < 0.7 ? 1.0 : (1.0 - (progress - 0.7) / 0.3);

        // Rotação
        final rotation = particle.rotation + progress * pi * 2;

        return Positioned(
          left: x,
          top: y,
          child: Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Icon(
                Icons.favorite,
                color: particle.color,
                size: particle.size,
              ),
            ),
          ),
        );
      },
    );
  }
}
