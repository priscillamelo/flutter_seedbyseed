import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/form_add_widget.dart';

class AddGerminationTest extends StatelessWidget {
  const AddGerminationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste de Germinação"),
      ),
      body: const FormAddWidget(),
    );
  }
}
