import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/flower_type.dart';
import '../widgets/flower_widget.dart';
import '../widgets/rising_hearts_widget.dart';
import '../widgets/garden_background.dart';

class GamePage extends StatefulWidget {
  final FlowerType flowerType;

  const GamePage({super.key, required this.flowerType});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int _totalPetals;
  late int _remainingPetals;
  bool _showHearts = false;

  // Game state
  bool _isLovesMe = true; // Starts with "Bem-me-quer"?
  // Traditionally:
  // 1st pull: Bem-me-quer
  // 2nd pull: Mal-me-quer
  // ...

  // But we want to SHOW the text for the NEXT pull or the LAST pull?
  // Usually you say the phrase AS you pull.
  // So initial state is empty or "Comece...".
  // When user clicks, we animate and show the text.

  String _currentStatus = "Toque numa pétala";
  bool _gameOver = false;
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    // Random petals between 7 and 12
    _totalPetals = 7 + Random().nextInt(6); // 7, 8, 9, 10, 11, 12
    _remainingPetals = _totalPetals;
    _statusColor = Colors.grey;
  }

  void _handlePetalRemoved(int remaining) {
    setState(() {
      _remainingPetals = remaining;

      // Update status
      // If we just removed a petal (so remaining decreased):
      // Calculate based on how many we've removed.
      int removedCount = _totalPetals - remaining;

      // 1st removed (odd): Bem-me-quer
      // 2nd removed (even): Mal-me-quer
      if (removedCount % 2 != 0) {
        _currentStatus = "Bem-me-quer";
        _statusColor = Theme.of(context).colorScheme.primary;
        _isLovesMe = true;
      } else {
        _currentStatus = "Mal-me-quer";
        _statusColor = Theme.of(context).colorScheme.secondary;
        _isLovesMe = false;
      }

      if (remaining == 0) {
        _finishGame();
      }
    });
  }

  void _finishGame() {
    setState(() {
      _gameOver = true;
      if (_isLovesMe) {
        _showHearts = true;
      }
    });

    // Show result dialog after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      _showResultDialog();
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isLovesMe ? Icons.favorite : Icons.heart_broken,
                color: _isLovesMe ? Colors.red : Colors.grey,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _isLovesMe ? "Bem-me-quer!" : "Mal-me-quer...",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _isLovesMe
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isLovesMe
                    ? "O amor está no ar! 💖"
                    : "Não desista, o amor virá! 🍃",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.pop(); // Close dialog
                      context.pop(); // Go back to home
                    },
                    child: const Text("Voltar"),
                  ),
                  FilledButton(
                    onPressed: () {
                      context.pop(); // Close dialog
                      // Restart game
                      setState(() {
                        _totalPetals = 7 + Random().nextInt(6);
                        _remainingPetals = _totalPetals;
                        _currentStatus = "Toque numa pétala";
                        _statusColor = Colors.grey;
                        _gameOver = false;
                        _showHearts = false;
                        // Force widget rebuild
                      });
                    },
                    child: const Text("Jogar Novamente"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.flowerType.name),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Garden background
          const Positioned.fill(
            child: GardenBackground(),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Status text area
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      _currentStatus,
                      key: ValueKey<String>(_currentStatus),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: _statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const Spacer(),

                // Flower
                Center(
                  child: FlowerWidget(
                    // Use a key to force rebuild when restarting game
                    key: ValueKey('flower_$_totalPetals'),
                    type: widget.flowerType,
                    petalCount: _totalPetals,
                    onPetalRemoved: _handlePetalRemoved,
                    isInteractive: !_gameOver,
                  ),
                ),

                const Spacer(flex: 2),

                // Hint text
                if (!_gameOver && _remainingPetals == _totalPetals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "Toque nas pétalas para removê-las",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ),
              ],
            ),
          ),

          // Rising hearts effect
          RisingHeartsWidget(
            isPlaying: _showHearts,
          ),
        ],
      ),
    );
  }
}
