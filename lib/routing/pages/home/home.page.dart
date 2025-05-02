import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/expenses/expense_card.dart';
import 'home.view_model.dart';

class HomePage extends GetView<HomeViewModel> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            if (controller.expenses?.length != null)
              SliverList.builder(
                itemCount: controller.expenses!.length,
                itemBuilder: (_, index) {
                  final data = controller.expenses![index];

                  return ExpenseCard(data: data);
                },
              ),
          ],
        ),
      ),
    );
  }
}
