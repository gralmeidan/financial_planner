import 'package:flutter/material.dart';

class AnimatedChevron extends StatefulWidget {
  final AnimationController controller;
  final Curve curve;
  final Color? color;

  const AnimatedChevron({
    super.key,
    required this.controller,
    this.curve = Curves.easeInOutCubic,
    this.color,
  });

  @override
  State<AnimatedChevron> createState() => _AnimatedChevronState();
}

class _AnimatedChevronState extends State<AnimatedChevron> {
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<double>(
      begin: 1,
      end: -1,
    ).animate(CurvedAnimation(parent: widget.controller, curve: widget.curve));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Transform.scale(
          scaleY: _animation.value,
          child: Icon(Icons.expand_more_rounded, color: widget.color),
        );
      },
    );
  }
}
