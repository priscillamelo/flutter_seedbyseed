import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/infra/route/routes.dart';
import 'package:flutter_seedbyseed/interface/widget/component/delete_germination_test.dart';
import 'package:flutter_seedbyseed/interface/widget/component/germination_test_card.dart';
import 'package:flutter_seedbyseed/persistence/repository/germination_test_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/repetition_repository.dart';
import 'package:provider/provider.dart';

class FinishedTab extends StatefulWidget {
  const FinishedTab({super.key});

  @override
  State<FinishedTab> createState() => _FinishedTabState();
}

class _FinishedTabState extends State<FinishedTab> {
  late GerminationTestRepository testRepository;
  late LotRepository lotRepository;
  late List<Lot> listLot;
  RepetitionRepository repetitionRepository = RepetitionRepository();
  List<int> listGerminatedSeeds = [];

  @override
  Widget build(BuildContext context) {
    testRepository = Provider.of<GerminationTestRepository>(context);
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
                        return GerminationTestCard(
                          germinationTest: data[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageRoutes.kDETAILS_GERMINATIONTEST,
                              arguments: data[index],
                            );
                          },
                          onLongPress: () => _confirmDeleteGerminationTest(context, data[index].id!),
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

  void _confirmDeleteGerminationTest(BuildContext context, int germinationTestId) {
    showConfirmationDialog(
      context: context,
      title: 'Remover teste',
      content: 'Deseja remover o teste de germinação?',
      onConfirm: () {
        setState(() {
          testRepository.deleteGerminationTest(germinationTestId);
        });
      },
    );
  }
}
