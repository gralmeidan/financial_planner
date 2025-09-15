import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/masks.dart';
import '../../../../utils/validators.dart';
import '../custom_form.dart';
import 'text_form_input_decoration.dart';

class TextFormInputController extends TextEditingController
    implements FormFieldController {
  final String? label;
  final String? prefix;
  final List<TextMask> masks;
  final List<Validator<String>> validators;
  final TextInputType? keyboardType;
  final String? placeholder;
  final FocusNode focusNode = FocusNode();

  TextFormInputController({
    this.label,
    this.prefix,
    this.keyboardType,
    this.masks = const [],
    this.validators = const [],
    this.placeholder,
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
  bool isFocused = false;
  bool isEmpty = false;

  void _handleFocusChange() {
    setState(() {
      isFocused = widget.controller.focusNode.hasFocus;
    });
  }

  void _handleTextChange() {
    setState(() {
      isEmpty = widget.controller.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);

    isEmpty = widget.controller.text.isEmpty;
  }

  @override
  void dispose() {
    widget.controller.focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  void deactivate() {
    // CustomForm.of(context).unregister(widget.controller);
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    // CustomForm.of(context).unregister(widget.controller);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // CustomForm.of(context).register(widget.controller);

    return TextFormInputDecoratedContainer(
      isFocused: isFocused,
      isEmpty: isEmpty,
      decoration: TextFormInputDecoration(
        label: widget.controller.label,
        placeholder: widget.controller.placeholder,

        prefix:
            widget.controller.prefix != null
                ? Trailing.text(
                  widget.controller.prefix!,
                  style: context.text.bodyLarge,
                )
                : null,
        suffix: Trailing.builder(
          (context, color) => IconButton(
            onPressed: () {
              widget.controller.clear();
              widget.controller.focusNode.requestFocus();
            },
            icon: Icon(Icons.cancel_outlined, color: color),
          ),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.controller.focusNode,
        style: context.text.bodyLarge!,
        cursorColor: context.colors.primary,
        decoration: null,
      ),
    );
  }
}
