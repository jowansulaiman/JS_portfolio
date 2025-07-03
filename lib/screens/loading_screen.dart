// lib/screens/loading_screen.dart (Test-Version ohne Logo)
import 'dart:math' as math;
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SunflowerLoadingAnimation(size: 200),
            const SizedBox(height: 32),
            Text(
              'Portfolio wird geladen...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SunflowerLoadingAnimation extends StatefulWidget {
  final double size;
  const SunflowerLoadingAnimation({super.key, this.size = 200});

  @override
  State<SunflowerLoadingAnimation> createState() => _SunflowerLoadingAnimationState();
}

class _SunflowerLoadingAnimationState extends State<SunflowerLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const int maxSeeds = 200;
  static const tau = math.pi * 2;
  static final phi = (math.sqrt(5) + 1) / 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0, end: maxSeeds.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final seeds = _animation.value.toInt();
          final scaleFactor = widget.size / 2 / math.sqrt(maxSeeds);

          return Stack(
            alignment: Alignment.center,
            children: [
              // HIER wurde das Logo für den Test auskommentiert
              // Image.asset('assets/icon/app_icon.png', width: widget.size / 3),

              ...List.generate(seeds, (i) {
                final theta = i * tau / phi;
                final r = math.sqrt(i) * scaleFactor;
                final x = r * math.cos(theta);
                final y = r * math.sin(theta);
                final normalizedR = r / (widget.size / 2);
                final opacity = (1 - normalizedR).clamp(0.2, 1.0);
                return Positioned(
                  left: (widget.size / 2) + x - 3,
                  top: (widget.size / 2) + y - 3,
                  child: _Dot(
                    color: Theme.of(context).colorScheme.primary.withOpacity(opacity),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}