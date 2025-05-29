import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_form.dart';

class ToggleFormInputController implements FormFieldController {
  late final RxBool _value;
  final String? label;

  ToggleFormInputController({this.label, bool initialValue = false}) {
    _value = RxBool(initialValue);
  }

  void dispose() {
    _value.close();
  }

  void toggle() {
    _value.value = !_value.value;
  }

  bool get value => _value.value;
  set value(bool value) => _value.value = value;

  @override
  bool validate() {
    return true;
  }
}

class ToggleFormInput extends StatelessWidget {
  final ToggleFormInputController controller;
  final EdgeInsets padding;

  const ToggleFormInput({
    super.key,
    required this.controller,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.toggle();
      },
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.label != null) Text(controller.label!),
            Obx(
              () => Switch(
                value: controller.value,
                onChanged: (newValue) {
                  controller.value = newValue;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
