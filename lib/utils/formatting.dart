import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
  decimalDigits: 2,
);

final _decimalFormatter = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: '',
  decimalDigits: 2,
);

final _noDecimalFormatter = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: '',
  decimalDigits: 0,
);

extension NumFormatting on double {
  String get toCurrency {
    return _currencyFormatter.format(this);
  }

  String get toDecimal {
    return _decimalFormatter.format(this);
  }

  String get toNoDecimal {
    return _noDecimalFormatter.format(this);
  }
}

extension NullNumFormatting on double? {
  String get toCurrency {
    if (this == null) return 'R\$ 0,00';

    return _currencyFormatter.format(this);
  }

  String get toDecimal {
    if (this == null) return '0,00';

    return _decimalFormatter.format(this);
  }

  String get toNoDecimal {
    if (this == null) return '0';

    return _noDecimalFormatter.format(this);
  }
}
