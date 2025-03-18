import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/slider_component.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RepetitionFutureBuilder extends StatefulWidget {
  final int idLot;
  final GerminationTest germinationTest;
  final bool lastPage;
  const RepetitionFutureBuilder(
      {super.key,
      required this.idLot,
      required this.lastPage,
      required this.germinationTest});

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
  int day = 1;

  @override
  void initState() {
    super.initState();
    repetitionRepository = RepetitionRepository();
    listRepetition = repetitionRepository.getAllRepetition(widget.idLot);
  }

  @override
  Widget build(BuildContext context) {
    int valueSlider = 0;
    if (widget.germinationTest.lastRecordedDate !=
        DateFormat('dd/MM/yyyy').format(DateTime.now())) {
      day = widget.germinationTest.currentDay;
    }
    GerminationTest test = widget.germinationTest;
    lotRepository = Provider.of<LotRepository>(context);
    testRepository = Provider.of<GerminationTestRepository>(context);
    return FutureBuilder(
        future: listRepetition,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (listGerminatedSeeds.isEmpty) {
              listGerminatedSeeds =
                  List.generate(snapshot.data!.length, (index) => 0);
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Dia $day - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        valueSlider = snapshot.data![index].seedsTotal -
                            snapshot.data![index].germinatedSeeds;

                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Repetição ${index + 1}"),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: valueSlider > 0
                                    ? SliderComponent(
                                        valueMax: valueSlider,
                                        totalGerminatedSeeds:
                                            (germinatedSeeds) {
                                          setState(() {
                                            listGerminatedSeeds[index] =
                                                germinatedSeeds.round();
                                          });
                                          debugPrint(
                                              "Lista de sementes germinadas: $listGerminatedSeeds");
                                        },
                                      )
                                    : const Text(
                                        "Todas as sementes foram germinadas!"),
                              ),
                            ]);
                      }),
                  ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    )),
                    onPressed: () async {
                      if (valueSlider > 0) {
                        Lot lot =
                            await lotRepository.getLot(test.id, widget.idLot);

                        for (int i = 0; i < snapshot.data!.length; i++) {
                          snapshot.data![i].germinatedSeeds +=
                              listGerminatedSeeds[i];
                          test.germinatedSeeds += listGerminatedSeeds[i];
                          repetitionRepository
                              .updateRepetition(snapshot.data![i]);
                          lot.germinatedSeedPerLot += listGerminatedSeeds[i];
                        }

                        debugPrint(
                            "ÚLTIMA DATA SALVA: ${test.lastRecordedDate}");
                        debugPrint("ÚLTIMO DIA SALVO: ${test.currentDay}");

                        if (test.lastRecordedDate !=
                            DateFormat('dd/MM/yyyy').format(DateTime.now())) {
                          test.currentDay++;
                          test.lastRecordedDate =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          debugPrint("${test.currentDay}");
                        }

                        lot.addDailyCount(day, listGerminatedSeeds);
                        if (day == test.lastCount) {
                          test.finished = 1;
                          //test.calculateIVG(lot);
                        }

                        debugPrint("DAILY COUNT: ${lot.dailyCount}");

                        testRepository.updateGerminationTest(test);
                        lotRepository.updateLot(lot);

                        if (context.mounted && widget.lastPage) {
                          Navigator.pop(context);
                        }
                      } else {
                        print(
                            "Status do teste de germinacao antes de finalizar: ${widget.germinationTest.finished}");
                        widget.germinationTest.finished = 1;
                        testRepository
                            .updateGerminationTest(widget.germinationTest);

                        print(
                            "Status do teste de germinacao depois de finalizar: ${widget.germinationTest.finished}");
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      valueSlider > 0
                          ? 'Salvar Dados'
                          : 'Finalizar Teste de Germinação',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]);
          } else {
            return const Center(
              child: Text('Nenhuma repetição cadastrado'),
            );
          }
        });
  }
}
