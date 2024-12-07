import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/slider_component.dart';
import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';

class RepetitionFutureBuilder extends StatefulWidget {
  final int idLot;
  const RepetitionFutureBuilder({super.key, required this.idLot});

  @override
  State<RepetitionFutureBuilder> createState() =>
      _RepetitionFutureBuilderState();
}

class _RepetitionFutureBuilderState extends State<RepetitionFutureBuilder> {
  late RepetitionRepository repetitionRepository;
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
                  onPressed: () {
                    for (int i = 0; i < snapshot.data!.length; i++) {
                      snapshot.data![i].germinatedSeeds +=
                          listGerminatedSeeds[i];
                      debugPrint(
                          "GERMINATED SEEDS: ${snapshot.data![i].germinatedSeeds}");
                      repetitionRepository.updateRepetition(snapshot.data![i]);
                    }

                    Navigator.pop(context);
                    //debugPrint("${listGerminatedSeeds.toString()}");
                  },
                  child: const Text(
                    'Salvar Dados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Nenhuma repetição cadastrado'),
            );
          }
        });
  }
}
