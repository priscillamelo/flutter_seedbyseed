import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/slider_component.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/domain/model/repetition.dart';
import 'package:flutter_seedbyseed/persistence/repository/germination_test_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/repetition_repository.dart';
import 'package:provider/provider.dart';

class RepetitionFutureBuilder extends StatefulWidget {
  final Lot lot;
  final GerminationTest germinationTest;
  final bool lastPage;
  final VoidCallback onUpdatePage;
  final bool isNewDay;

  const RepetitionFutureBuilder({
    super.key,
    required this.lot,
    required this.lastPage,
    required this.germinationTest,
    required this.onUpdatePage,
    required this.isNewDay,
  });

  @override
  State<RepetitionFutureBuilder> createState() => _RepetitionFutureBuilderState();
}

class _RepetitionFutureBuilderState extends State<RepetitionFutureBuilder> {
  late RepetitionRepository repetitionRepository;
  late LotRepository lotRepository;
  late GerminationTestRepository testRepository;
  late Future<List<Repetition>> listRepetition;
  List<int> listGerminatedSeeds = [];

  @override
  void initState() {
    super.initState();
    repetitionRepository = RepetitionRepository();
    listRepetition = repetitionRepository.getAllRepetition(widget.lot.id);
  }

  @override
  Widget build(BuildContext context) {
    lotRepository = Provider.of<LotRepository>(context);
    testRepository = Provider.of<GerminationTestRepository>(context);
    return FutureBuilder(
        future: listRepetition,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (listGerminatedSeeds.isEmpty) {
              final int currentDay = widget.germinationTest.currentDay;
              debugPrint("CURRENTDAY: $currentDay");
              listGerminatedSeeds = List.from(widget.lot.dailyCount[currentDay]!);
            }
            //debugPrint("${widget.lot.dailyCount[currentDay]!}");
            /*final List<int> dayData = widget.lot.dailyCount[currentDay]!;
            final firstEntry = widget.lot.dailyCount.entries.first;

            listGerminatedSeeds = List.generate(
              firstEntry.value!.length,
              (index) => dayData[index],
            );*/

            return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Repetition repetition = snapshot.data![index];

                    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("Repetição ${index + 1}"),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SliderComponent(
                          valueMax: repetition.seedsTotal,
                          totalGerminatedSeeds: (germinatedSeeds) {
                            listGerminatedSeeds[index] = germinatedSeeds.round();

                          },
                          valueStart: listGerminatedSeeds[index],
                        ),
                      ),
                    ]);
                  }),
              ElevatedButton(
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                ),
                onPressed: () async {
                  await saveGerminationSeedsRepetition(snapshot.data!, listGerminatedSeeds);
                  await saveGerminationSeedsLot(snapshot.data!);

                  debugPrint("Lista de Sementes Germinadas -> $listGerminatedSeeds");

                  int daysOfCount = widget.germinationTest.lastCount - widget.germinationTest.firstCount;

                  bool lastDay = widget.germinationTest.currentDay == daysOfCount;

                  // verifica se é o último dia do teste de germinação para poder realizar o cálculo do IVG do Lote e mudar o status do teste para finalizado
                  if (lastDay) {
                    widget.lot.calculateIVGPerLot();
                    lotRepository.updateLot(widget.lot);
                    if (widget.lastPage) {
                      widget.germinationTest.status = GerminationTest.finished;
                      testRepository.updateGerminationTest(widget.germinationTest);
                    }
                  }

                  // verifica se não é a última página de lotes: caso não seja, atualiza a página para o próximo lote, caso contrário, realiza o Navigator.pop()
                  if (!widget.lastPage) {
                    widget.onUpdatePage();
                  } else {
                    await saveGerminationSeedsTestGermination();
                    if(context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text(
                  "Salvar dados",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]);
          } else {
            return const Center(
              child: Text('Nenhuma repetição cadastrada'),
            );
          }
        });
  }

  Future<void> saveGerminationSeedsRepetition(List<Repetition> listRepetition, List<int> listGerminatedSeeds) async {

    for (int i = 0; i < listRepetition.length; i++) {
      if(widget.isNewDay) {
        listRepetition[i].germinatedSeeds += listGerminatedSeeds[i];
        debugPrint("Novo Dia: R${i + 1} -> ${listRepetition[i].germinatedSeeds}");
      } else {
        int newGerminatedSeeds = listGerminatedSeeds[i] - listRepetition[i].germinatedSeeds;
        debugPrint("Novas Sementes Germinadas: R${i + 1} -> $newGerminatedSeeds");
        listRepetition[i].germinatedSeeds += newGerminatedSeeds;
      }
      await repetitionRepository.updateRepetition(listRepetition[i]);
    }
  }

  /*void saveGerminationSeedsLot(List<Repetition> listRepetition) async {
    widget.lot.dailyCount[widget.germinationTest.currentDay] =
        listRepetition.map((repetition) => repetition.germinatedSeeds).toList();

    //calcularGerminadasPorRepeticao(widget.lot.dailyCount);

    for (var element in widget.lot.dailyCount.values) {
      widget.lot.germinatedSeedPerLot += element!.reduce((a, b) => a + b);
    }

    await lotRepository.updateLot(widget.lot);
  }*/

  Future<void> saveGerminationSeedsLot(List<Repetition> listRepetition) async {
    widget.lot.dailyCount[widget.germinationTest.currentDay] = listRepetition.map((repetition) => repetition.germinatedSeeds).toList();
    debugPrint("DAILYCOUNT DO LOTE: ${widget.lot.numberLot}: ${widget.lot.dailyCount[widget.germinationTest.currentDay]}");
    widget.lot.germinatedSeedPerLot = listRepetition.fold(0, (sum, repetition) => sum + repetition.germinatedSeeds);

    await lotRepository.updateLot(widget.lot);
  }

  Future<void> saveGerminationSeedsTestGermination() async {
    // Busca todos os lotes associados ao teste
    final lots = await lotRepository.getAllLots(widget.germinationTest.id);

    final totalGerminatedSeeds = lots.fold<int>(0, (sum, lot) => sum + lot.germinatedSeedPerLot);

    widget.germinationTest.germinatedSeeds = totalGerminatedSeeds;
    await testRepository.updateGerminationTest(widget.germinationTest);
  }
}
