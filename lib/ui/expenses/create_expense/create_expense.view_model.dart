import 'package:flutter/material.dart';

import '../../../utils/masks.dart';
import '../../../utils/validators.dart';
import '../../core/form/form.dart';
import '../../core/helpers/view_model.dart';

class OtherViewModel extends ViewModel {
  final nameController = TextFormInputController(
    label: 'Nome',
    placeholder: 'Ex: Detergente, Desodorante, etc',
  );
}

class CreateExpenseViewModel extends ViewModel {
  final nameController = TextFormInputController(
    label: 'Nome',
    placeholder: 'Ex: Detergente, Desodorante, etc',
  );
  final valueController = TextFormInputController(
    label: 'Valor',
    prefix: 'R\$ ',
    placeholder: '0,00',
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
