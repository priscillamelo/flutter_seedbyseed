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
  final int idLot;
  final int idGerminationTest;
  final bool lastPage;
  const RepetitionFutureBuilder(
      {super.key,
      required this.idLot,
      required this.lastPage,
      required this.idGerminationTest});

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

  @override
  void initState() {
    super.initState();
    repetitionRepository = RepetitionRepository();
    listRepetition = repetitionRepository.getAllRepetition(widget.idLot);
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
              listGerminatedSeeds =
                  List.generate(snapshot.data!.length, (index) => 0);
            }
            int currentDay = snapshot.data!.first.currentDay;
            if (currentDay == 0) currentDay++;
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Dia $currentDay",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Repetição ${index + 1}"),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SliderComponent(
                                  valueMax: snapshot.data![index].seedsTotal,
                                  totalGerminatedSeeds: (germinatedSeeds) {
                                    setState(() {
                                      listGerminatedSeeds[index] =
                                          germinatedSeeds.round();
                                    });
                                    debugPrint(
                                        "Lista de sementes germinadas: $listGerminatedSeeds");
                                  },
                                ),
                              ),
                            ]);
                      }),
                  ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    )),
                    onPressed: () async {
                      Lot lot = await lotRepository.getLot(
                          widget.idGerminationTest, widget.idLot);
                      GerminationTest? test = await testRepository
                          .getGerminationTest(widget.idGerminationTest);

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        snapshot.data![i].germinatedSeeds +=
                            listGerminatedSeeds[i];
                        test.germinatedSeeds += listGerminatedSeeds[i];

                        /*       debugPrint(
                            "TOTAL DE SEMENTES GERMINADAS DA REPETIÇÃO $i: ${snapshot.data![i].germinatedSeeds}"); */
                        repetitionRepository
                            .updateRepetition(snapshot.data![i]);

                        lot.germinatedSeedPerLot += listGerminatedSeeds[i];
                      }
                      debugPrint(
                          "TOTAL DE SEMENTES GERMINADAS DO LOTE ${lot.id}: ${lot.germinatedSeedPerLot}");

                      /* debugPrint(
                            "TOTAL DE SEMENTES GERMINADAS DO TESTE DE GERMINAÇÃO ${test.id}: ${test.germinatedSeeds}"); */
                      //test.germinatedSeeds = lot.germinatedSeedPerLot;

                      testRepository.updateGerminationTest(test);
                      debugPrint(
                          "TOTAL DE SEMENTES GERMINADAS DO TESTE DE GERMINAÇÃO ${test.id}: ${test.germinatedSeeds}");

                      lotRepository.updateLot(lot);

                      if (context.mounted && widget.lastPage) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Salvar Dados',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
