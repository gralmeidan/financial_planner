import 'package:flutter/material.dart';

import 'text_form_input_decoration.render.dart';

const _kDefPadding = EdgeInsets.all(16);
const _kDefSpacing = 8.0;

enum _TrailingType { text, child, builder }

class Trailing {
  final Widget? child;
  final String? text;
  final TextStyle? style;
  final Widget Function(BuildContext context, Color? color)? builder;

  final _TrailingType _type;

  const Trailing.text(this.text, {this.style})
    : child = null,
      builder = null,
      _type = _TrailingType.text;

  const Trailing.child(this.child)
    : text = null,
      style = null,
      builder = null,
      _type = _TrailingType.child;

  const Trailing.builder(this.builder)
    : text = null,
      style = null,
      child = null,
      _type = _TrailingType.builder;

  Widget build(BuildContext context, Color? color) {
    switch (_type) {
      case _TrailingType.text:
        return Text(
          text ?? '',
          style: style?.copyWith(color: color) ?? TextStyle(color: color),
        );
      case _TrailingType.child:
        return child ?? const SizedBox.shrink();
      case _TrailingType.builder:
        return builder!.call(context, color);
    }
  }
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
    final isShowingPlaceholder =
        widget.isEmpty && (decor?.label == null || isLabelOnTop);

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
      isShowingPlaceholder: isShowingPlaceholder,
      contentPadding: decor?.contentPadding ?? _kDefPadding,
      spacing: _kDefSpacing,
      prefix: decor?.prefix,
      suffix: decor?.suffix,
      child: widget.child,
    );
  }
}

class _AnimatedBorder extends StatefulWidget {
  final Widget child;
  final Trailing? prefix;
  final Trailing? suffix;

  final String? label;
  final TextStyle? labelStyle;
  final bool isLabelOnTop;

  final String? placeholder;
  final TextStyle? placeholderStyle;
  final bool isShowingPlaceholder;

  final Color color;
  final double spacing;
  final BorderRadius borderRadius;
  final EdgeInsets contentPadding;

  const _AnimatedBorder({
    required this.child,
    required this.color,
    required this.borderRadius,
    required this.spacing,
    required this.label,
    required this.labelStyle,
    required this.placeholder,
    required this.placeholderStyle,
    required this.contentPadding,
    required this.prefix,
    required this.suffix,
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
    )..value = widget.isLabelOnTop ? 1.0 : 0.0;
    _labelAnimation = CurvedAnimation(
      parent: _labelController,
      curve: Curves.easeInOutQuad,
    );

    _placeholderController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      reverseDuration: const Duration(milliseconds: 100),
    )..value = widget.isShowingPlaceholder ? 1.0 : 0.0;
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
        _placeholderController.forward();
      } else {
        _placeholderController.reverse();
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

  InputLayoutId _buildTrailing(
    BuildContext context,
    Trailing trailing,
    InputSlot slot,
  ) {
    Widget child;

    if (trailing.child == null) {
      child = AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return trailing.build(context, _colorAnimation.value);
        },
      );
    } else {
      child = trailing.build(context, _colorAnimation.value);
    }

    return InputLayoutId(slot: slot, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return RenderInputDecoration(
      borderRadius: widget.borderRadius,
      contentPadding: widget.contentPadding,
      spacing: widget.spacing,
      color: _colorAnimation,
      labelT: _labelAnimation,
      labelText: widget.label,
      labelStyle: widget.labelStyle,
      placeHolderT: _placeholderAnimation,
      placeHolderText: widget.placeholder,
      placeHolderStyle: widget.placeholderStyle,
      children: [
        if (widget.prefix != null)
          _buildTrailing(context, widget.prefix!, InputSlot.prefix),
        InputLayoutId(slot: InputSlot.input, child: widget.child),
        if (widget.suffix != null)
          _buildTrailing(context, widget.suffix!, InputSlot.suffix),
      ],
    );
  }
}
