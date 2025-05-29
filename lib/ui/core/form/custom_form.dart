import 'package:flutter/material.dart';

abstract class FormFieldController {
  bool validate();
}

class CustomForm extends StatefulWidget {
  final Widget child;

  const CustomForm({super.key, required this.child});

  static CustomFormState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_CustomFormScope>();
    assert(scope != null, 'CustomForm not found in context');
    return scope!.state;
  }

  @override
  State<CustomForm> createState() => CustomFormState._();
}

class CustomFormState extends State<CustomForm> {
  CustomFormState._();

  final Set<FormFieldController> _controllers = {};

  void register(FormFieldController controller) {
    _controllers.add(controller);
  }

  void unregister(FormFieldController controller) {
    _controllers.remove(controller);
  }

  void replace(
    FormFieldController oldController,
    FormFieldController newController,
  ) {
    _controllers.remove(oldController);
    _controllers.add(newController);
  }

  bool validate() {
    for (final controller in _controllers) {
      if (!controller.validate()) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _CustomFormScope(state: this, child: widget.child);
  }
}

class _CustomFormScope extends InheritedWidget {
  final CustomFormState state;

  const _CustomFormScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(_CustomFormScope oldWidget) {
    return false;
  }
}
