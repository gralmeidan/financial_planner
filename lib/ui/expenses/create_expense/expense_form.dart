import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/form/custom_form.dart';
import '../../core/form/form.dart';
import 'create_expense.view_model.dart';

class ExpenseFormBottomSheet extends StatefulWidget {
  const ExpenseFormBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      builder: (context) {
        final insets = MediaQuery.of(context).viewInsets;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: max(insets.bottom, 128)),
            child: const ExpenseFormBottomSheet(),
          ),
        );
      },
    );
  }

  @override
  State<ExpenseFormBottomSheet> createState() => _ExpenseFormBottomSheetState();
}

class _ExpenseFormBottomSheetState extends State<ExpenseFormBottomSheet> {
  final controller = Get.find<CreateExpenseViewModel>();

  static const _padding = EdgeInsets.symmetric(horizontal: 24);

  @override
  Widget build(BuildContext context) {
    return CustomForm(
      child: Column(
        children: [
          Padding(
            padding: _padding,
            child: Column(
              spacing: 16,
              children: [
                TextFormInput(controller: controller.nameController),
                TextFormInput(controller: controller.valueController),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ToggleFormInput(
            controller: controller.recurrentController,
            padding: _padding,
          ),
          ToggleFormInput(
            controller: controller.fixedController,
            padding: _padding,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: _padding.copyWith(bottom: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Salvar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
