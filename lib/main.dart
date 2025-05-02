import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routing/pages/home/home.view_model.dart';
import 'routing/routing.dart';
import 'styles/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.dark,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.home,
      initialBinding: AppBindings(),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeViewModel());
  }
}
