import 'package:get/get.dart';

class AsyncResponse<T> {
  final RxBool loading = false.obs;
  final Rx<String?> error = Rx(null);
  final Rx<T?> data = Rx(null);

  AsyncResponse();

  void dispose() {
    loading.close();
    error.close();
    data.close();
  }
}
