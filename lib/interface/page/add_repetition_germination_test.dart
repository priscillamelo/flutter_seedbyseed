import 'package:flutter/material.dart';

class AddRepetitionGerminationTest extends StatefulWidget {
  const AddRepetitionGerminationTest({super.key});

  @override
  State<AddRepetitionGerminationTest> createState() =>
      _AddRepetitionGerminationTestState();
}

class _AddRepetitionGerminationTestState
    extends State<AddRepetitionGerminationTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seed By Seed"),
      ),
    );
  }
}
