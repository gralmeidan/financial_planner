import 'dart:math';

import 'package:flutter/services.dart';

typedef TextMask = String Function(String value);

abstract final class Mask {
  static final _currencyRegex = RegExp(r'^(\d+(,?\d*)?)');

  static String currency(String value) {
    final match = _currencyRegex.matchAsPrefix(value.replaceAll('.', ','));
    String? group = match?.group(0);

    return group ?? '';
  }
}

extension InputFormatterExtension on TextMask {
  TextInputFormatter get toInputFormatter =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        final newText = this(newValue.text);

        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(
            offset: min(newValue.selection.baseOffset, newText.length),
          ),
        );
      });
}
