import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/lot_future_builder.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/verify_date.dart';

class AddGerminatedSeeds extends StatefulWidget {
  const AddGerminatedSeeds({super.key});

  @override
  State<AddGerminatedSeeds> createState() => _AddSeedGerminationState();
}

class _AddSeedGerminationState extends State<AddGerminatedSeeds> {
  late GerminationTest germinationTest;
  late bool isAvailableDayCount;
  late Future<void> _initFuture;
  bool isNewDay = false;

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
    isNewDay = await VerifyDate.loadAndCompareDate(DateTime.now());

    isAvailableDayCount = germinationTest.verifyIsFirstCountAvailable();
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
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
          }

            if (isAvailableDayCount) {
              return LotFutureBuilder(
                germinationTest: germinationTest,
                isNewDay: isNewDay,
              );
            } else {
              final firstCountDate = germinationTest.calculateFirstCountDate();
              final String formattedDate =
                  "${firstCountDate.day}/${firstCountDate.month}/${firstCountDate.year}";
              return Text(
                  "A contagem das sementes se inicia no dia $formattedDate");
            }

        },
      ),
    );
  }
}
