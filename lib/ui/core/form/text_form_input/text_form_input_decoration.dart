import 'package:flutter/material.dart';

const _kDefPadding = EdgeInsets.all(16);

class Trailing {
  final Widget? child;
  final String? text;
  final TextStyle? style;

  const Trailing.text(this.text, {this.style}) : child = null;

  const Trailing({required Widget this.child}) : text = null, style = null;
}

class TextFormInputDecoration {
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Trailing? prefix;
  final Trailing? suffix;
  final String? label;
  final TextStyle? labelStyle;

  const TextFormInputDecoration({
    this.contentPadding,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.prefix,
    this.suffix,
    this.label,
    this.labelStyle,
  });
}

class TextFormInputDecoratedContainer extends StatefulWidget {
  final Widget child;
  final TextFormInputDecoration? decoration;
  final bool isFocused;
  final bool isEmpty;

  const TextFormInputDecoratedContainer({
    super.key,
    required this.child,
    this.decoration,
    this.isFocused = false,
    this.isEmpty = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _TextFormInputDecoratedContainerState();
  }
}

class _TextFormInputDecoratedContainerState
    extends State<TextFormInputDecoratedContainer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final decor = widget.decoration;

    return _AnimatedBorder(
      color:
          widget.isFocused
              ? decor?.focusedBorderColor ?? colors.primary
              : decor?.borderColor ?? colors.outline,
      borderRadius:
          decor?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
      label: decor?.label,
      labelStyle: decor?.labelStyle ?? theme.textTheme.bodyLarge,
      isLabelOnTop: !widget.isFocused,
      contentPadding: decor?.contentPadding ?? _kDefPadding,
      child: Padding(
        padding: decor?.contentPadding ?? _kDefPadding,
        child: Row(children: [Expanded(child: widget.child)]),
      ),
    );

    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     borderRadius:
    //         decor?.borderRadius ?? const BorderRadius.all(Radius.circular(8.0)),
    //     border: Border.fromBorderSide(
    //       BorderSide(color: decor?.borderColor ?? colors.outline, width: 1.0),
    //     ),
    //   ),
    //   child: Padding(padding: const EdgeInsets.all(16.0), child: widget.child),
    // );
  }
}

class _AnimatedBorder extends StatefulWidget {
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;
  final String? label;
  final TextStyle? labelStyle;
  final bool isLabelOnTop;
  final EdgeInsets contentPadding;

  const _AnimatedBorder({
    required this.child,
    required this.color,
    required this.borderRadius,
    required this.label,
    required this.labelStyle,
    required this.contentPadding,
    this.isLabelOnTop = false,
  });

  @override
  State<_AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<_AnimatedBorder>
    with TickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _labelController;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: widget.color,
      end: widget.color,
    ).animate(_colorController);

    _labelController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedBorder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.color) {
      _colorAnimation = ColorTween(
        begin: _colorAnimation.value ?? oldWidget.color,
        end: widget.color,
      ).animate(_colorController);

      _colorController.forward(from: 0.0);
    }

    if (oldWidget.isLabelOnTop != widget.isLabelOnTop) {
      if (widget.isLabelOnTop) {
        _labelController.forward();
      } else {
        _labelController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _BorderPainter(
              color: _colorAnimation,
              repaint: Listenable.merge([_colorController, _labelController]),
              borderRadius: widget.borderRadius,
              label: _labelController,
              labelStyle: widget.labelStyle,
              labelText: widget.label,
              contentPadding: widget.contentPadding,
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _BorderPainter extends CustomPainter {
  final Animation<Color?> color;
  final AnimationController label;
  final BorderRadius borderRadius;
  final String? labelText;
  final TextStyle? labelStyle;
  final EdgeInsets? contentPadding;

  _BorderPainter({
    required this.color,
    required this.borderRadius,
    required this.label,
    required this.labelStyle,
    required this.labelText,
    this.contentPadding,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (color.value == null) return;

    final paint =
        Paint()
          ..color = color.value!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
      ),
      paint,
    );

    if (labelText != null) {
      final textPainter = TextPainter(
        text: TextSpan(text: labelText, style: labelStyle ?? const TextStyle()),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      );

      textPainter.layout(
        maxWidth:
            size.width -
            (contentPadding?.left ?? 0) -
            (contentPadding?.right ?? 0),
      );

      final offset = Offset(
        contentPadding?.left ?? 0,
        (size.height - textPainter.height) / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _BorderPainter) {
      return oldDelegate.color.value != color.value;
    }

    return false;
  }
}
