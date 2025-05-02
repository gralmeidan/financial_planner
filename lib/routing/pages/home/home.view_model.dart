import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../../data/models/schema.dart';
import '../../../data/repositories/repositories.dart';
import '../../../utils/async_response.dart';

class HomeViewModel extends GetxController {
  final repository = RecordRepository();

  final period = AsyncResponse<FinancialPeriod>();
  RealmList<FinancialRecord>? get expenses => period.data.value?.expense;

  void _fetchPeriod() {
    final data = repository.getPeriod();
    period.data.value = data;
  }

  @override
  void onInit() {
    super.onInit();
    _fetchPeriod();
  }
}
