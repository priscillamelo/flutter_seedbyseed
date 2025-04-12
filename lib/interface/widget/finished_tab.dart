import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/route/routes.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';
import 'package:provider/provider.dart';

class FinishedTab extends StatefulWidget {
  const FinishedTab({super.key});

  @override
  State<FinishedTab> createState() => _FinishedTabState();
}

class _FinishedTabState extends State<FinishedTab> {
  late LotRepository lotRepository;
  late List<Lot> listLot;
  RepetitionRepository repetitionRepository = RepetitionRepository();
  List<int> listGerminatedSeeds = [];

  @override
  Widget build(BuildContext context) {
    GerminationTestRepository testRepository =
        Provider.of<GerminationTestRepository>(context);
    lotRepository = Provider.of<LotRepository>(context);

    return Scaffold(
      body: FutureBuilder(
          future: testRepository.getAllFinishedGerminationTest(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var data = snapshot.data;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageRoutes.kDETAILS_GERMINATIONTEST,
                              arguments: data[index],
                            );
                          },
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[index].species),
                                Text(
                                    "Sementes Germinadas: ${data[index].germinatedSeeds}"),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TODO: CRIAR UM COMPONENT DE TEXT()
                                Flexible(
                                  child: Text(
                                    "Temperatura: ${data[index].temperature}",
                                  ),
                                ),
                                /* Flexible(
                                  child: Text(
                                    "Dia Atual: ${1}/${data[index].duration}",
                                  ),
                                ), */
                                Flexible(
                                  child: Text(
                                    "Contagem Inicial: ${data[index].firstCount}",
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "Contagem Final: ${data[index].lastCount}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Não Há Testes Finalizados!"));
            }
          }),
    );
  }
}
