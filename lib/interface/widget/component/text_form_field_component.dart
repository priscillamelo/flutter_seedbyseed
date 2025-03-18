import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String textLabel;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String suffixText;

  const TextFormFieldComponent(
      {super.key,
      required this.textLabel,
      required this.controller,
      required this.textInputType,
      required this.suffixText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(labelText: textLabel, suffixText: suffixText),
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
