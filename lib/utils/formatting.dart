import 'package:intl/intl.dart';

final _numFormatter = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
  decimalDigits: 2,
);

extension NumFormatting on double {
  String get toCurrency {
    return _numFormatter.format(this);
  }
}

extension NullNumFormatting on double? {
  String get toCurrency {
    if (this == null) return 'R\$ 0,00';

    return _numFormatter.format(this);
  }
}
