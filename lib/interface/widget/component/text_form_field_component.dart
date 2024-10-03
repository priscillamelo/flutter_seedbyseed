import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String textLabel;
  final TextEditingController controller;
  final TextInputType textInputType;

  const TextFormFieldComponent(
      {super.key,
      required this.textLabel,
      required this.controller,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      maxLength: textLabel == "Lote" ? 1 : null,
      decoration: InputDecoration(
        labelText: textLabel,
        suffixText: textLabel == "Duração" ? "dias" : null,
        suffix: textLabel == "Lote"
            ? IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_rounded))
            : null,
      ),
      validator: _validatorField,
    );
  }

  String? _validatorField(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira o dado!";
    }

    return null;
  }
}
