import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/lot_future_builder.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/verify_date.dart';

class AddGerminatedSeeds extends StatefulWidget {
  const AddGerminatedSeeds({super.key});

  @override
  State<AddGerminatedSeeds> createState() => _AddGerminatedSeedsState();
}

class _AddGerminatedSeedsState extends State<AddGerminatedSeeds> {
  late GerminationTest germinationTest;
  late bool isAvailableDayCount;
  late Future<void> _initFuture;

  bool _isInitialized = false;
  bool isNewDay = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      germinationTest =
          ModalRoute.of(context)!.settings.arguments as GerminationTest;
      _initFuture = _init();
      _isInitialized = true;
    }
  }

  Future<void> _init() async {
    await Future<void>.delayed(Duration.zero); // Garante acesso ao contexto
    if (!mounted) return;
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Erro ao carregar os dados.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return LotFutureBuilder(
            germinationTest: germinationTest,
            isNewDay: isNewDay,
          );
        },
      ),
    );
  }
}
