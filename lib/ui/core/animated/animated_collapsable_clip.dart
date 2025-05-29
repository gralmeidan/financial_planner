import 'package:flutter/material.dart';

class AnimatedCollapsableClip extends StatefulWidget {
  final Widget child;
  final AnimationController controller;
  final double padding;
  final double collapsedHeight;
  final Curve curve;

  const AnimatedCollapsableClip({
    super.key,
    required this.child,
    required this.controller,
    this.padding = 0,
    this.collapsedHeight = 0,
    this.curve = Curves.easeInOutCubic,
  });

  @override
  State<AnimatedCollapsableClip> createState() =>
      _AnimatedCollapsableClipState();
}

class _AnimatedCollapsableClipState extends State<AnimatedCollapsableClip> {
  final GlobalKey _childKey = GlobalKey();
  Animation<double>? _animation;
  double _maxSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    final renderObject = _childKey.currentContext?.findRenderObject();
    final size = renderObject is RenderBox ? renderObject.size : Size.zero;

    double maxSize = size.height + widget.padding;

    if (maxSize == _maxSize) {
      return;
    }

    _maxSize = maxSize;

    _animation = Tween<double>(
      begin: widget.collapsedHeight,
      end: _maxSize,
    ).animate(CurvedAnimation(parent: widget.controller, curve: widget.curve));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        if (_animation == null) {
          return ClipRect(
            child: SizedOverflowBox(
              alignment: Alignment.topCenter,
              size: Size(double.infinity, widget.collapsedHeight),
              child: child,
            ),
          );
        } else {
          if (_animation!.value == _maxSize) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _afterLayout(null);
            });

            return child!;
          }

          return ClipRect(
            child: SizedOverflowBox(
              alignment: Alignment.topCenter,
              size: Size(double.infinity, _animation!.value),
              child: child,
            ),
          );
        }
      },
      child: SizedBox(key: _childKey, child: widget.child),
    );
  }
}

class AnimatedCollapsableController {
  late final AnimationController size;
  late final AnimationController chevron;

  AnimatedCollapsableController({
    required TickerProvider vsync,
    required Duration duration,
  }) {
    size = AnimationController(vsync: vsync, duration: duration);
    chevron = AnimationController(vsync: vsync, duration: duration);
  }

  void dispose() {
    size.dispose();
    chevron.dispose();
  }

  void forward() {
    size.forward();
    chevron.forward();
  }

  void reverse() {
    size.reverse();
    chevron.reverse();
  }

  void trigger(bool isExpanded) {
    if (isExpanded) {
      forward();
    } else {
      reverse();
    }
  }
}
