import 'package:flutter/material.dart';

class DancingDots extends StatefulWidget {
  final Color color;

  const DancingDots({Key? key, this.color = Colors.blue}) : super(key: key);

  @override
  _DancingDotsState createState() => _DancingDotsState();
}

class _DancingDotsState extends State<DancingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..addListener(() => setState(() {}));
    });

    _animations = _controllers
        .map(
          (controller) => Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ),
          ),
        )
        .toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (final controller in _controllers) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        // Add this check
        controller.repeat(reverse: true);
      } else {
        break; // Exit the loop if the widget is no longer mounted
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _animations
          .map(
            (animation) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Transform.scale(
                scale: 0.5 + animation.value * 0.5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
