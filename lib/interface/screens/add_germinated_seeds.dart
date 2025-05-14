import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/lot_future_builder.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/verify_date.dart';

class AddGerminatedSeeds extends StatefulWidget {
  const AddGerminatedSeeds({super.key});

  @override
  State<AddGerminatedSeeds> createState() => _AddSeedGerminationState();
}

class _AddSeedGerminationState extends State<AddGerminatedSeeds> {
  late GerminationTest germinationTest;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _init(); // Inicia a verificação logo no início
  }

  Future<void> _init() async {
    await Future.delayed(Duration.zero); // Garante acesso ao contexto
    if (!mounted) return;
    germinationTest =
        ModalRoute.of(context)!.settings.arguments as GerminationTest;
    bool isNewDay = await VerifyDate.loadAndCompareDate(DateTime.now());
    debugPrint("isNewDay: $isNewDay");

    if (isNewDay) {
      setState(() {
        germinationTest.currentDay++; // Atualiza localmente
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sementes Germinadas'),
      ),
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
          } else {
            return LotFutureBuilder(germinationTest: germinationTest);
          }
        },
      ),
    );
  }
}
