import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/form/form.dart';
import '../../core/helpers/view_model.dart';
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

class _ExpenseFormBottomSheetState
    extends ViewModelState<ExpenseFormBottomSheet, CreateExpenseViewModel> {
  @override
  CreateExpenseViewModel createViewModel() => CreateExpenseViewModel();

  static const _padding = EdgeInsets.symmetric(horizontal: 24);

  @override
  Widget build(BuildContext context) {
    return ViewModelContext(
      viewModel: viewModel,
      child: CustomForm(
        child: Column(
          children: [
            Padding(
              padding: _padding,
              child: Column(
                spacing: 16,
                children: [
                  TextFormInput(controller: viewModel.nameController),
                  TextFormInput(controller: viewModel.valueController),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ToggleFormInput(
              controller: viewModel.recurrentController,
              padding: _padding,
            ),
            ToggleFormInput(
              controller: viewModel.fixedController,
              padding: _padding,
            ),
            const SizedBox(height: 32),
            const _TestWidget(),
            Padding(
              padding: _padding.copyWith(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ExpenseFormBottomSheet.show(context);
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestWidget extends StatelessWidget {
  const _TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModelContext.of<CreateExpenseViewModel>(context);

    return ValueListenableBuilder(
      valueListenable: viewModel.nameController,
      builder: (_, __, ___) {
        return Text(viewModel.nameController.text);
      },
    );
  }
}
