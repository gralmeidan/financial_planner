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
  final String? placeholder;
  final TextStyle? placeholderStyle;

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
    this.placeholder,
    this.placeholderStyle,
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

    final isLabelOnTop = widget.isFocused || !widget.isEmpty;
    final isShowingPlaceholder = widget.isEmpty;

    return _AnimatedBorder(
      color:
          widget.isFocused
              ? decor?.focusedBorderColor ?? colors.primary
              : decor?.borderColor ?? colors.outline,
      borderRadius:
          decor?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
      label: decor?.label,
      labelStyle: decor?.labelStyle ?? theme.textTheme.bodyLarge,
      isLabelOnTop: isLabelOnTop,
      placeholder: decor?.placeholder,
      placeholderStyle: decor?.placeholderStyle ?? theme.textTheme.bodyMedium,
      isShowingPlaceholder:
          isShowingPlaceholder && (decor?.label == null || !isLabelOnTop),
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

  final String? placeholder;
  final TextStyle? placeholderStyle;
  final bool isShowingPlaceholder;

  final EdgeInsets contentPadding;

  const _AnimatedBorder({
    required this.child,
    required this.color,
    required this.borderRadius,
    required this.label,
    required this.labelStyle,
    required this.placeholder,
    required this.placeholderStyle,
    required this.contentPadding,
    this.isLabelOnTop = false,
    this.isShowingPlaceholder = false,
  });

  @override
  State<_AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<_AnimatedBorder>
    with TickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _labelController;
  late Animation<double> _labelAnimation;

  late AnimationController _placeholderController;
  late Animation<double> _placeholderAnimation;

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
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _labelAnimation = CurvedAnimation(
      parent: _labelController,
      curve: Curves.easeInOutQuad,
    );

    _placeholderController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _placeholderAnimation = CurvedAnimation(
      parent: _placeholderController,
      curve: Curves.easeInOutQuad,
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

    if (oldWidget.isShowingPlaceholder != widget.isShowingPlaceholder) {
      if (widget.isShowingPlaceholder) {
        _placeholderController.reverse();
      } else {
        _placeholderController.forward();
      }
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _labelController.dispose();
    _placeholderController.dispose();
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
              label: _labelAnimation,
              labelStyle: widget.labelStyle,
              labelText: widget.label,
              contentPadding: widget.contentPadding,
              placeholderText: widget.placeholder,
              placeholderStyle: widget.placeholderStyle,
              placeholder: _placeholderAnimation,
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
  final Animation<double> label;
  final Animation<double> placeholder;
  final BorderRadius borderRadius;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? placeholderText;
  final TextStyle? placeholderStyle;
  final EdgeInsets? contentPadding;

  _BorderPainter({
    required this.color,
    required this.borderRadius,
    required this.label,
    required this.labelStyle,
    required this.labelText,
    required this.placeholder,
    required this.placeholderStyle,
    required this.placeholderText,
    this.contentPadding,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double borderHole = 0.0;

    if (labelText != null) {
      final value = label.value;
      final scaleDown = 0.1 * value;
      final style = labelStyle ?? const TextStyle();

      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: style.copyWith(
            fontSize: style.fontSize! * (1 - scaleDown),
            color: color.value ?? Colors.black,
          ),
        ),
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
        (size.height - textPainter.height) / 2 -
            value * (textPainter.height * (1 + scaleDown)),
      );

      borderHole = textPainter.size.width * value;

      textPainter.paint(canvas, offset);
    }

    if (placeholderText != null) {
      final value = placeholder.value;
      final style = placeholderStyle ?? const TextStyle(color: null);

      final textPainter = TextPainter(
        text: TextSpan(
          text: placeholderText,
          style: style.copyWith(
            color: (style.color ?? color.value)?.withAlpha(
              (value * 160).toInt(),
            ),
          ),
        ),
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

    if (color.value != null) {
      final paint =
          Paint()
            ..color = color.value!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;

      final rect = RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
      );

      if (borderHole > 0) {
        // Draw border with a "hole" at the top for the label
        final path = Path();

        // Calculate the start and end of the hole
        final holeStart = (contentPadding?.left ?? 0) - 4.0; // small margin
        final holeEnd = holeStart + borderHole + 8.0; // small margin

        // Top border: left to holeStart
        path.moveTo(rect.left + rect.tlRadiusX, rect.top);
        path.lineTo(holeStart, rect.top);

        // Move to after the hole
        path.moveTo(holeEnd, rect.top);
        path.lineTo(rect.right - rect.trRadiusX, rect.top);

        // Top-right corner
        path.arcToPoint(
          Offset(rect.right, rect.top + rect.trRadiusY),
          radius: Radius.circular(rect.trRadiusX),
          clockwise: true,
        );

        // Right border
        path.lineTo(rect.right, rect.bottom - rect.brRadiusY);

        // Bottom-right corner
        path.arcToPoint(
          Offset(rect.right - rect.brRadiusX, rect.bottom),
          radius: Radius.circular(rect.brRadiusX),
          clockwise: true,
        );

        // Bottom border
        path.lineTo(rect.left + rect.blRadiusX, rect.bottom);

        // Bottom-left corner
        path.arcToPoint(
          Offset(rect.left, rect.bottom - rect.blRadiusY),
          radius: Radius.circular(rect.blRadiusY),
          clockwise: true,
        );

        // Left border
        path.lineTo(rect.left, rect.top + rect.tlRadiusY);

        // Top-left corner
        path.arcToPoint(
          Offset(rect.left + rect.tlRadiusX, rect.top),
          radius: Radius.circular(rect.tlRadiusX),
          clockwise: true,
        );

        canvas.drawPath(path, paint);
      } else {
        canvas.drawRRect(rect, paint);
      }
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
