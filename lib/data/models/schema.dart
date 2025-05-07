import 'package:realm/realm.dart';

part 'schema.realm.dart';

@RealmModel()
class _FinancialRecord {
  late String name;
  late double? amount;
  late DateTime createdAt;
  List<_FinancialRecord> children = [];

  double get total {
    if (children.isNotEmpty) {
      return children.fold(0, (previousValue, element) {
        return previousValue + (element.total);
      });
    }

    return amount ?? 0;
  }
}

@RealmModel()
class _FinancialPeriod {
  late String? name;
  late DateTime start;
  late DateTime end;
  List<_FinancialRecord> expense = [];
  List<_FinancialRecord> income = [];
}
