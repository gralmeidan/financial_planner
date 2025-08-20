import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum InputSlot { prefix, input, suffix }

class _InputIdParentData extends ContainerBoxParentData<RenderBox> {
  InputSlot? slot;
}

class InputLayoutId extends ParentDataWidget<_InputIdParentData> {
  final InputSlot slot;

  const InputLayoutId({super.key, required this.slot, required super.child});

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as _InputIdParentData;

    if (parentData.slot != slot) {
      parentData.slot = slot;
      renderObject.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => RenderInputDecoration;
}

class RenderInputDecoration extends MultiChildRenderObjectWidget {
  final BorderRadius borderRadius;
  final EdgeInsets contentPadding;
  final double spacing;

  final Animation<Color?> color;
  final Animation<double> labelT;
  final String? labelText;
  final TextStyle? labelStyle;

  final Animation<double> placeHolderT;
  final String? placeHolderText;
  final TextStyle? placeHolderStyle;

  const RenderInputDecoration({
    super.key,
    required this.borderRadius,
    required this.contentPadding,
    required this.spacing,
    required this.color,
    required this.labelT,
    this.labelText,
    this.labelStyle,
    required this.placeHolderT,
    this.placeHolderText,
    this.placeHolderStyle,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputDecorator(
      borderRadius: borderRadius,
      contentPadding: contentPadding,
      spacing: spacing,
      color: color,
      labelT: labelT,
      labelText: labelText,
      labelStyle: labelStyle,
      placeholderT: placeHolderT,
      placeholderText: placeHolderText,
      placeholderStyle: placeHolderStyle,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    // ignore: library_private_types_in_public_api
    covariant _RenderInputDecorator renderObject,
  ) {
    renderObject
      ..borderRadius = borderRadius
      ..contentPadding = contentPadding
      ..spacing = spacing
      ..attachListenables(
        color: color,
        labelT: labelT,
        placeholderT: placeHolderT,
      )
      ..labelText = labelText
      ..labelStyle = labelStyle
      ..placeholderText = placeHolderText
      ..placeholderStyle = placeHolderStyle;
  }
}

class _RenderInputDecorator extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _InputIdParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _InputIdParentData> {
  _RenderInputDecorator({
    required BorderRadius borderRadius,
    required EdgeInsets contentPadding,
    required double spacing,
    required Animation<Color?> color,
    required Animation<double> labelT,
    required String? labelText,
    required TextStyle? labelStyle,
    required Animation<double> placeholderT,
    required String? placeholderText,
    required TextStyle? placeholderStyle,
  }) : _borderRadius = borderRadius,
       _contentPadding = contentPadding,
       _spacing = spacing,
       _labelText = labelText,
       _labelStyle = labelStyle,
       _placeholderText = placeholderText,
       _placeholderStyle = placeholderStyle,
       _color = color {
    attachListenables(color: color, labelT: labelT, placeholderT: placeholderT);
  }

  BorderRadius _borderRadius;
  set borderRadius(BorderRadius v) {
    if (_borderRadius == v) return;
    _borderRadius = v;
    markNeedsPaint();
  }

  EdgeInsets _contentPadding;
  set contentPadding(EdgeInsets v) {
    if (_contentPadding == v) return;
    _contentPadding = v;
    markNeedsLayout();
  }

  double _spacing;
  set spacing(double v) {
    if (_spacing == v) return;
    _spacing = v;
    markNeedsLayout();
  }

  final TextPainter _labelPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
    ellipsis: '…',
  );

  final TextPainter _placeholderPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
    ellipsis: '…',
  );

  TextSpan _makeSpan(String? text, TextStyle? style) =>
      TextSpan(text: text, style: style);

  String? _labelText;
  set labelText(String? v) {
    if (_labelText == v) return;
    _labelText = v;
    _labelPainter.text = _makeSpan(_labelText, _labelStyle);
    markNeedsPaint();
  }

  TextStyle? _labelStyle;
  set labelStyle(TextStyle? v) {
    if (_labelStyle == v) return;
    _labelStyle = v;
    _labelPainter.text = _makeSpan(_labelText, _labelStyle);
    markNeedsPaint();
  }

  String? _placeholderText;
  set placeholderText(String? v) {
    if (_placeholderText == v) return;
    _placeholderText = v;
    _placeholderPainter.text = _makeSpan(_placeholderText, _placeholderStyle);
    markNeedsPaint();
  }

  TextStyle? _placeholderStyle;
  set placeholderStyle(TextStyle? v) {
    if (_placeholderStyle == v) return;
    _placeholderStyle = v;
    _placeholderPainter.text = _makeSpan(_placeholderText, _placeholderStyle);
    markNeedsPaint();
  }

  Animation<Color?>? _color;
  Animation<double?>? _labelT;
  Animation<double?>? _placeholderT;

  void _swapListenable<T extends Listenable>(T? oldL, T newL, VoidCallback cb) {
    if (identical(oldL, newL)) return;
    oldL?.removeListener(cb);
    newL.addListener(cb);
  }

  void attachListenables({
    required Animation<Color?> color,
    required Animation<double> labelT,
    required Animation<double> placeholderT,
  }) {
    _swapListenable(_labelT, labelT, markNeedsPaint);
    _swapListenable(_placeholderT, placeholderT, markNeedsPaint);
    _swapListenable(_color, color, markNeedsPaint);

    _labelT = labelT;
    _placeholderT = placeholderT;
    _color = color;
  }

  Map<InputSlot, RenderBox>? _getChildrenBySlots() {
    final children = <InputSlot, RenderBox>{};
    RenderBox? child = firstChild;

    while (child != null) {
      final parentData = child.parentData as _InputIdParentData?;

      if (parentData?.slot != null) {
        children[parentData!.slot!] = child;
      }

      child = parentData?.nextSibling;
    }

    return children;
  }

  RenderBox? get _prefix => _getChildrenBySlots()?[InputSlot.prefix];
  RenderBox get _input =>
      _getChildrenBySlots()?[InputSlot.input] ??
      (throw StateError('A child with InputSlot.input is required'));
  RenderBox? get _suffix => _getChildrenBySlots()?[InputSlot.suffix];

  @override
  double computeMinIntrinsicWidth(double height) {
    final prefix = _prefix?.getMinIntrinsicWidth(height) ?? 0;
    final input = _input.getMinIntrinsicWidth(height);
    final suffix = _suffix?.getMinIntrinsicWidth(height) ?? 0;
    return _contentPadding.horizontal + prefix + input + suffix;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final prefix = _prefix?.getMaxIntrinsicWidth(height) ?? 0;
    final input = _input.getMaxIntrinsicWidth(height);
    final suffix = _suffix?.getMaxIntrinsicWidth(height) ?? 0;
    return _contentPadding.horizontal + prefix + input + suffix;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final innerW =
        width.isFinite
            ? (width - _contentPadding.horizontal).clamp(0.0, double.infinity)
            : double.infinity;
    final h = [
      _prefix?.getMinIntrinsicHeight(innerW) ?? 0,
      _input.getMinIntrinsicHeight(innerW),
      _suffix?.getMinIntrinsicHeight(innerW) ?? 0,
    ].fold<double>(0, (a, b) => a > b ? a : b);
    return _contentPadding.vertical + h;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final innerW =
        width.isFinite
            ? (width - _contentPadding.horizontal).clamp(0.0, double.infinity)
            : double.infinity;
    final h = [
      _prefix?.getMaxIntrinsicHeight(innerW) ?? 0,
      _input.getMaxIntrinsicHeight(innerW),
      _suffix?.getMaxIntrinsicHeight(innerW) ?? 0,
    ].fold<double>(0, (a, b) => a > b ? a : b);
    return _contentPadding.vertical + h;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    // Rough pass similar to performLayout without laying out children.
    final hasBoundedW = constraints.hasBoundedWidth;
    final width =
        hasBoundedW
            ? constraints.maxWidth
            : computeMaxIntrinsicWidth(double.infinity);
    final height = computeMinIntrinsicHeight(width);

    return constraints.constrain(Size(width, height));
  }

  @override
  void setupParentData(covariant RenderBox child) {
    if (child.parentData is! _InputIdParentData) {
      child.parentData = _InputIdParentData();
    }
  }

  Size _layoutAndGetSize(InputSlot slot, BoxConstraints constraints) {
    final child = _getChildrenBySlots()?[slot];
    if (child == null) return Size.zero;
    child.layout(constraints, parentUsesSize: true);
    return child.size;
  }

  bool _setOffset(InputSlot slot, Offset offset) {
    final child = _getChildrenBySlots()?[slot];
    if (child == null) return false;
    final parentData = child.parentData as _InputIdParentData;
    parentData.offset = offset;
    return true;
  }

  @override
  void performLayout() {
    final hasBoundedW = constraints.hasBoundedWidth;
    final hasBoundedH = constraints.hasBoundedHeight;
    final maxW = hasBoundedW ? constraints.maxWidth : double.infinity;

    final loose = BoxConstraints.loose(Size(maxW, constraints.maxHeight));

    final prefixSize = _layoutAndGetSize(InputSlot.prefix, loose);
    final inputSize = _layoutAndGetSize(InputSlot.input, loose);
    final suffixSize = _layoutAndGetSize(InputSlot.suffix, loose);

    double availableWidth;

    final leftGap = prefixSize.width > 0 ? _spacing : 0.0;
    final rightGap = suffixSize.width > 0 ? _spacing : 0.0;

    if (maxW.isFinite) {
      availableWidth = max(
        maxW -
            _contentPadding.horizontal -
            prefixSize.width -
            suffixSize.width -
            leftGap -
            rightGap,
        0.0,
      );
    } else {
      availableWidth = double.infinity;
    }

    final inputConstraints = BoxConstraints(
      maxWidth: availableWidth,
      maxHeight: inputSize.height,
    );

    _input.layout(inputConstraints, parentUsesSize: true);

    final rawW =
        _contentPadding.horizontal +
        prefixSize.width +
        _input.size.width +
        suffixSize.width +
        leftGap +
        rightGap;
    final width = hasBoundedW ? constraints.constrainWidth(rawW) : rawW;

    final rawH =
        _contentPadding.vertical +
        max(_input.size.height, max(prefixSize.height, suffixSize.height));
    final height = hasBoundedH ? constraints.constrainHeight(rawH) : rawH;

    size = Size(width, height);
    double centerY(double h) =>
        _contentPadding.top + (height - _contentPadding.vertical - h) / 2;

    double x = _contentPadding.left;

    if (_setOffset(InputSlot.prefix, Offset(x, centerY(prefixSize.height)))) {
      x += prefixSize.width + leftGap;
    }

    if (_setOffset(InputSlot.input, Offset(x, centerY(inputSize.height)))) {
      x += _input.size.width + rightGap;
    }

    if (_setOffset(InputSlot.suffix, Offset(x, centerY(suffixSize.height)))) {
      x += suffixSize.width;
    }

    _prefixW = prefixSize.width;
    _suffixW = suffixSize.width;
  }

  // Usado no paint
  double _prefixW = 0.0;
  double _suffixW = 0.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final rect = offset & size;
    double borderHole = 0.0;

    final leftGap = (_prefixW > 0 ? _spacing + _prefixW : 0.0);
    final rightGap = (_suffixW > 0 ? _spacing + _suffixW : 0.0);

    if (_labelText != null) {
      final value = _labelT?.value ?? 0.0;
      final scaleDown = 0.1 * value;
      final style = _labelStyle ?? const TextStyle();

      final textPainter = TextPainter(
        text: TextSpan(
          text: _labelText,
          style: style.copyWith(
            fontSize: style.fontSize! * (1 - scaleDown),
            color: _color?.value ?? Colors.black,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      );

      final disregardedLeftConstraints = leftGap * value;
      final disregardedRightConstraints = rightGap * value;
      final disregardedHorizontalConstraints =
          disregardedLeftConstraints + disregardedRightConstraints;

      textPainter.layout(
        maxWidth:
            size.width -
            (_contentPadding.left) -
            (_contentPadding.right) -
            _prefixW -
            rightGap +
            disregardedHorizontalConstraints,
      );

      final labelOffset =
          offset +
          Offset(
            _contentPadding.left + leftGap - disregardedLeftConstraints,
            (size.height - textPainter.height) / 2 -
                value * (textPainter.height * (1 + scaleDown)),
          );

      borderHole = textPainter.size.width * value;

      textPainter.paint(canvas, labelOffset);
    }

    if (_placeholderText != null) {
      final value = _placeholderT?.value ?? 0.0;
      final style = _placeholderStyle ?? const TextStyle(color: null);

      final textPainter = TextPainter(
        text: TextSpan(
          text: _placeholderText,
          style: style.copyWith(
            color: (style.color ?? _color?.value)?.withAlpha(
              (value * 160).toInt(),
            ),
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      );

      textPainter.layout(
        maxWidth: size.width - (_contentPadding.left) - (_contentPadding.right),
      );

      final placeHolderOffset =
          offset +
          Offset(
            _contentPadding.left + leftGap,
            (size.height - textPainter.height) / 2,
          );

      textPainter.paint(canvas, placeHolderOffset);
    }

    if (_color?.value != null) {
      final paint =
          Paint()
            ..color = _color!.value!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;

      final rrect = RRect.fromLTRBAndCorners(
        rect.left,
        rect.top,
        rect.right,
        rect.top + rect.height,
        bottomLeft: _borderRadius.bottomLeft,
        bottomRight: _borderRadius.bottomRight,
        topLeft: _borderRadius.topLeft,
        topRight: _borderRadius.topRight,
      );

      if (borderHole > 0) {
        // Draw border with a "hole" at the top for the label
        final path = Path();

        // Calculate the start and end of the hole
        final holeStart =
            (_contentPadding.left + rect.left) - 4.0; // small margin
        final holeEnd = holeStart + borderHole + 8.0; // small margin

        // Top border: left to holeStart
        path.moveTo(rrect.left + rrect.tlRadiusX, rrect.top);
        path.lineTo(holeStart, rrect.top);

        // Move to after the hole
        path.moveTo(holeEnd, rrect.top);
        path.lineTo(rrect.right - rrect.trRadiusX, rrect.top);

        // Top-right corner
        path.arcToPoint(
          Offset(rrect.right, rrect.top + rrect.trRadiusY),
          radius: Radius.circular(rrect.trRadiusX),
          clockwise: true,
        );

        // Right border
        path.lineTo(rrect.right, rrect.bottom - rrect.brRadiusY);

        // Bottom-right corner
        path.arcToPoint(
          Offset(rrect.right - rrect.brRadiusX, rrect.bottom),
          radius: Radius.circular(rrect.brRadiusX),
          clockwise: true,
        );

        // Bottom border
        path.lineTo(rrect.left + rrect.blRadiusX, rrect.bottom);

        // Bottom-left corner
        path.arcToPoint(
          Offset(rrect.left, rrect.bottom - rrect.blRadiusY),
          radius: Radius.circular(rrect.blRadiusY),
          clockwise: true,
        );

        // Left border
        path.lineTo(rrect.left, rrect.top + rrect.tlRadiusY);

        // Top-left corner
        path.arcToPoint(
          Offset(rrect.left + rrect.tlRadiusX, rrect.top),
          radius: Radius.circular(rrect.tlRadiusX),
          clockwise: true,
        );

        canvas.drawPath(path, paint);
      } else {
        canvas.drawRRect(rrect, paint);
      }
    }

    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
