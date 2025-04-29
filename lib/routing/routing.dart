import 'package:get/get.dart';

import 'pages/pages.dart';

abstract final class AppRoutes {
  static const String home = '/';

  static final List<GetPage> pages = [
    GetPage(name: home, page: () => const HomePage()),
  ];
}
