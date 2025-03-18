import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/lot_future_builder.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';

class AddGerminatedSeeds extends StatefulWidget {
  const AddGerminatedSeeds({super.key});

  @override
  State<AddGerminatedSeeds> createState() => _AddSeedGerminationState();
}

class _AddSeedGerminationState extends State<AddGerminatedSeeds> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as GerminationTest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sementes Germinadas'),
      ),
      body: LotFutureBuilder(germinationTest: arg),
    );
  }
}
