import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/masks.dart';
import '../../../utils/validators.dart';
import '../../core/form/custom_form.dart';
import '../../core/form/form.dart';

class CreateExpenseViewModel extends GetxController {
  final nameController = TextFormInputController(
    label: 'Nome Long Coisa Grande, Muito Grande, Muito, Muito Grande',
  );
  final valueController = TextFormInputController(
    label: 'Valor',
    prefix: 'R\$ ',
    keyboardType: TextInputType.number,
    masks: [Mask.currency],
    validators: [Validators.required],
  );
  final recurrentController = ToggleFormInputController(label: 'Recorrente');
  final fixedController = ToggleFormInputController(label: 'Fixo');

  void onSubmit(BuildContext context) {
    final form = CustomForm.of(context);

    if (!form.validate()) {
      return;
    }
  }
}
