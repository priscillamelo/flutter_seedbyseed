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
  State<RepetitionFutureBuilder> createState() =>
      _RepetitionFutureBuilderState();
}

class _RepetitionFutureBuilderState extends State<RepetitionFutureBuilder> {
  late RepetitionRepository repetitionRepository;
  late LotRepository lotRepository;
  late GerminationTestRepository testRepository;
  late Future<List<Repetition>> listRepetition;
  List<int> listGerminatedSeeds = [];
  bool hasChanges = false;
  late int differenceDays;
  late DateTime firstCount;

  @override
  void initState() {
    super.initState();
    repetitionRepository = RepetitionRepository();
    listRepetition = repetitionRepository.getAllRepetition(widget.lot.id);
    firstCount = widget.germinationTest
        .calculateCountDate(widget.germinationTest.firstCount);
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
              listGerminatedSeeds = List.from(
                  widget.lot.dailyCount[widget.germinationTest.currentDay]!);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Repetition repetition = snapshot.data![index];
                        //bool enabledSlider = repetition.germinatedSeeds == repetition.seedsTotal;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Repetição ${index + 1}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.eco,
                                          size: 20, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SliderComponent(
                                          valueMax:
                                              repetition.seedsTotal.toDouble(),
                                          totalGerminatedSeeds:
                                              (germinatedSeeds) {
                                            setState(() {
                                              listGerminatedSeeds[index] =
                                                  germinatedSeeds.round();
                                              hasChanges = true;
                                            });
                                          },
                                          valueStart: listGerminatedSeeds[index]
                                              .toDouble(),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${listGerminatedSeeds[index]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      }),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Salvar dados",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: hasChanges
                        ? () async {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const AlertDialog(
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text("Salvando..."),
                                  ],
                                ),
                              ),
                            );
                            await saveGerminationSeedsRepetition(
                                snapshot.data!);
                            await saveGerminationSeedsLot(snapshot.data!);
                            await saveGerminationSeedsTestGermination();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Dados salvos com sucesso!"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.fixed,
                                ),
                              );
                            }
                            if (context.mounted) {
                              Navigator.pop(context); // Fecha o diálogo
                            }

                            int daysOfCount = widget.germinationTest.lastCount;

                            bool lastDay = (widget.germinationTest.currentDay ==
                                daysOfCount);

                            // verifica se é o último dia do teste de germinação para poder realizar o cálculo do IVG do Lote e mudar o status do teste para finalizado
                            if (lastDay) {
                              widget.lot.calculateIVGPerLot();
                              await widget.lot
                                  .calculateTotalGerminatedSeedPerLot();
                              await lotRepository.updateLot(widget.lot);
                              await widget.germinationTest
                                  .totalGerminatedSeedGerminationTest(
                                      widget.germinationTest.id!);

                              if (widget.lastPage) {
                                widget.germinationTest.status =
                                    GerminationTest.finished;
                              }
                              await testRepository.updateGerminationTest(
                                  widget.germinationTest);
                            }

                            // verifica se não é a última página de lotes: caso não seja, atualiza a página para o próximo lote, caso contrário, realiza o Navigator.pop()
                            if (!widget.lastPage) {
                              widget.onUpdatePage();
                            } else {

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          } else {
            return const Center(
              child: Text('Nenhuma repetição cadastrada'),
            );
          }
        });
  }

  Future<void> saveGerminationSeedsRepetition(
      List<Repetition> listRepetition) async {
    for (int i = 0; i < listRepetition.length; i++) {
      if (widget.isNewDay) {
        listRepetition[i].germinatedSeeds += listGerminatedSeeds[i];
      } else {
        int newGerminatedSeeds =
            listGerminatedSeeds[i] - listRepetition[i].germinatedSeeds;

        listRepetition[i].germinatedSeeds += newGerminatedSeeds;
      }
      await repetitionRepository.updateRepetition(listRepetition[i]);
    }
  }

  Future<void> saveGerminationSeedsLot(List<Repetition> listRepetition) async {
    widget.lot.dailyCount[widget.germinationTest.currentDay] =
        listGerminatedSeeds;

    widget.lot.germinatedSeedPerLot = listRepetition.fold(
        0, (sum, repetition) => sum + repetition.germinatedSeeds);

    await lotRepository.updateLot(widget.lot);
  }

  Future<void> saveGerminationSeedsTestGermination() async {
    // Busca todos os lotes associados ao teste
    final lots = await lotRepository.getAllLots(widget.germinationTest.id!);

    final totalGerminatedSeeds =
        lots.fold<int>(0, (sum, lot) => sum + lot.germinatedSeedPerLot);

    debugPrint("Sementes Germinadas do Teste: $totalGerminatedSeeds");

    widget.germinationTest.germinatedSeeds = totalGerminatedSeeds;
    await testRepository.updateGerminationTest(widget.germinationTest);
  }
}
