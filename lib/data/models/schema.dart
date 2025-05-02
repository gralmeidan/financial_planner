import 'package:realm/realm.dart';

part 'schema.realm.dart';

@RealmModel()
class _FinancialRecord {
  late String name;
  late double? amount;
  late DateTime createdAt;
  List<_FinancialRecord> children = [];
}

@RealmModel()
class _FinancialPeriod {
  late String? name;
  late DateTime start;
  late DateTime end;
  List<_FinancialRecord> expense = [];
  List<_FinancialRecord> income = [];
}
