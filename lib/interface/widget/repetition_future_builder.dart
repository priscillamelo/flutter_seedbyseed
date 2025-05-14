import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/slider_component.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';
import 'package:provider/provider.dart';

class RepetitionFutureBuilder extends StatefulWidget {
  final Lot lot;
  final GerminationTest germinationTest;
  final bool lastPage;
  final VoidCallback onUpdatePage;

  const RepetitionFutureBuilder({
    super.key,
    required this.lot,
    required this.lastPage,
    required this.germinationTest,
    required this.onUpdatePage,
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
            List<int> listGerminatedSeeds =
                List.generate(snapshot.data!.length, (index) => snapshot.data![index].germinatedSeeds);

            debugPrint("listGerminatedSeeds: $listGerminatedSeeds");

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Repetition repetition = snapshot.data![index];
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Repetição ${index + 1}"),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SliderComponent(
                                  valueMax: repetition.seedsTotal,
                                  totalGerminatedSeeds: (germinatedSeeds) {
                                    listGerminatedSeeds[index] =
                                        germinatedSeeds.round();
                                  },
                                  valueStart: repetition.germinatedSeeds,
                                ),
                              ),
                            ]);
                      }),
                  ElevatedButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                    ),
                    onPressed: () async {
                      saveGerminationSeedsRepetition(
                          snapshot.data!, listGerminatedSeeds);

                      int daysOfCount = widget.germinationTest.lastCount -
                          widget.germinationTest.firstCount;

                      bool lastDay =
                          widget.germinationTest.currentDay == daysOfCount;

                      // verifica se é o último dia do teste de germinação para poder realizar o cálculo do IVG do Lote e mudar o status do teste para finalizado
                      if (lastDay) {
                        widget.lot.calculateIVGPerLot();
                        lotRepository.updateLot(widget.lot);
                        if (widget.lastPage) {
                          widget.germinationTest.status =
                              GerminationTest.finished;
                          testRepository
                              .updateGerminationTest(widget.germinationTest);
                        }
                      }

                      // verifica se não é a última página de lotes: caso não seja, atualiza a página para o próximo lote, caso contrário, realiza o Navigator.pop()
                      if (!widget.lastPage) {
                        widget.onUpdatePage();
                      } else {
                        saveGerminationSeedsTestGermination();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Salvar dados",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  void saveGerminationSeedsRepetition(
      List<Repetition> listRepetition, List<int> listGerminatedSeeds) {
    for (int i = 0; i < listRepetition.length; i++) {
      Repetition repetition = listRepetition[i];
      repetition.germinatedSeeds = listGerminatedSeeds[i];
      repetitionRepository.updateRepetition(repetition);
    }
    saveGerminationSeedsLot(listRepetition);
  }

  void saveGerminationSeedsLot(List<Repetition> listRepetition) {
    widget.lot.dailyCount[widget.germinationTest.currentDay] =
        listRepetition.map((repetition) => repetition.germinatedSeeds).toList();
    widget.lot.germinatedSeedPerLot = listRepetition.fold(
        0, (sum, repetition) => sum + repetition.germinatedSeeds);

    lotRepository.updateLot(widget.lot);
  }

  void saveGerminationSeedsTestGermination() async {
    // Busca todos os lotes associados ao teste
    final lots = await lotRepository.getAllLots(widget.germinationTest.id);

    // Soma todas as sementes germinadas de todos os lotes
    final totalGerminatedSeeds =
        lots.fold<int>(0, (sum, lot) => sum + lot.germinatedSeedPerLot);

    widget.germinationTest.germinatedSeeds = totalGerminatedSeeds;
    testRepository.updateGerminationTest(widget.germinationTest);
  }
}
