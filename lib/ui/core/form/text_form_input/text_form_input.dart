import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/masks.dart';
import '../../../../utils/validators.dart';
import '../custom_form.dart';

class TextFormInputController extends TextEditingController
    implements FormFieldController {
  final String? label;
  final String? prefix;
  final List<TextMask> masks;
  final List<Validator<String>> validators;
  final TextInputType? keyboardType;

  TextFormInputController({
    this.label,
    this.prefix,
    this.keyboardType,
    this.masks = const [],
    this.validators = const [],
  });

  List<TextInputFormatter> get inputFormatters =>
      masks.map((mask) => mask.toInputFormatter).toList();

  @override
  bool validate() {
    for (final validator in validators) {
      if (validator(text) != null) {
        return false;
      }
    }

    return true;
  }
}

class TextFormInput extends StatefulWidget {
  final TextFormInputController controller;

  const TextFormInput({super.key, required this.controller});

  @override
  State<TextFormInput> createState() => _TextFormInputState();
}

class _TextFormInputState extends State<TextFormInput> {
  bool showSufix = false;

  void _handleTextChange() {
    setState(() {
      showSufix = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  void deactivate() {
    CustomForm.of(context).unregister(widget.controller);
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    CustomForm.of(context).unregister(widget.controller);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    CustomForm.of(context).register(widget.controller);

    return TextFormField(
      controller: widget.controller,
      inputFormatters: widget.controller.inputFormatters,
      keyboardType: widget.controller.keyboardType,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        labelText: widget.controller.label,
        prefixText: widget.controller.prefix,
        suffix: Visibility(
          visible: showSufix,
          replacement: const SizedBox(height: 24),
          child: InkWell(
            onTap: () {
              widget.controller.clear();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.cancel_outlined,
                color:
                    Theme.of(context).inputDecorationTheme.outlineBorder?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
