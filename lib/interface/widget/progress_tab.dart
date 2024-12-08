import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/floating_button_component.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/route/routes.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';
import 'package:provider/provider.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
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
          future: testRepository.getAllGerminationTest(),
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
                              PageRoutes.kADD_GERMINATEDSEEDS,
                              arguments: data[index],
                            );
                          },
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Remover teste"),
                                    content: const Text(
                                        "Deseja remover o teste de germinação?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          testRepository.deleteGerminationTest(
                                              data[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Remover"),
                                      ),
                                    ],
                                  );
                                });
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
                  const Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingButtonSmallComponent()),
                ],
              );
            } else {
              return const TabProgressNoData();
            }
          }),
    );
  }
}

class TabProgressNoData extends StatelessWidget {
  const TabProgressNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingButtonLargeComponent(),
          SizedBox(
            height: 16,
          ),
          Text("Iniciar Teste de Germinação"),
        ],
      ),
    );
  }
}
