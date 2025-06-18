import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String textLabel;
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData? icon;

  const TextFormFieldComponent({
    super.key,
    required this.textLabel,
    required this.controller,
    required this.textInputType,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          style: const TextStyle(
            fontSize: 16,
          ),
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            label: AutoSizeText(
              textLabel,
              maxLines: 2,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
          validator: _validatorField,
        ),
        const SizedBox(height: 16), // Espaçamento padrão entre campos
      ],
    );
  }

  String? _validatorField(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira o dado!";
    }

    return null;
  }
}
