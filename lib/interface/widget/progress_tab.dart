import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/infra/config/notification_local_service.dart';
import 'package:flutter_seedbyseed/interface/widget/component/delete_germination_test.dart';
import 'package:flutter_seedbyseed/interface/widget/component/floating_button_component.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/infra/route/routes.dart';
import 'package:flutter_seedbyseed/interface/widget/component/germination_test_card.dart';
import 'package:flutter_seedbyseed/persistence/repository/germination_test_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/repetition_repository.dart';
import 'package:provider/provider.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
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
          future: testRepository.getAllProgressGerminationTest(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text("Erro ao carregar dados: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const TabProgressNoData();
            }

            var data = snapshot.data!;

            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    data.sort((a, b) => a
                        .calculateCountDate(data[index].firstCount)
                        .compareTo(
                            b.calculateCountDate(data[index].firstCount)));

                    return GerminationTestCard(
                      germinationTest: data[index],
                      onTap: data[index].verifyIsFirstCountAvailable()
                          ? () {
                              Navigator.pushNamed(
                                context,
                                PageRoutes.kADD_GERMINATEDSEEDS,
                                arguments: data[index],
                              );
                            }
                          : null,
                      onLongPress: () => _showTestOptions(context, data[index]),
                    );
                  },
                ),
                const Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingButtonSmallComponent()),
              ],
            );
          }),
    );
  }

  void _showTestOptions(BuildContext context, GerminationTest test) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar teste'),
              onTap: () {
                Navigator.pop(context);
                // Redirecionar para a tela de edição
                Navigator.pushNamed(
                  context,
                  '/editar-teste',
                  arguments: test,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Finalizar teste'),
              onTap: () {
                Navigator.pop(context);
                _confirmFinalizeTest(context, test);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Remover teste'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteTest(context, test.id!);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteTest(BuildContext context, int testId) {
    showConfirmationDialog(
      context: context,
      title: 'Remover teste',
      content: 'Deseja remover o teste de germinação?',
      onConfirm: () async {
        await NotificationLocalService().cancelGerminationNotification(testId);
        setState(() {
          testRepository.deleteGerminationTest(testId);
        });
      },
    );
  }

  void _confirmFinalizeTest(BuildContext context, GerminationTest test) {
    showConfirmationDialog(
      context: context,
      title: 'Finalizar teste',
      content: 'Deseja finalizar este teste agora?',
      onConfirm: () async {
        await finishTest(test);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Teste finalizado com sucesso!"),
              duration: Duration(seconds: 2),
            ),
          );
        }

        await NotificationLocalService()
            .cancelGerminationNotification(test.id!);
      },
    );
  }

  Future<void> finishTest(GerminationTest test) async {
    listLot = await lotRepository.getAllLots(test.id!);
    for (var lot in listLot) {
      lot.calculateIVGPerLot();
      await lot.calculatePercAverageGerminatedSeeds();
      await lot.calculateTotalGerminatedSeedPerLot();

      await lotRepository.updateLot(lot);
      debugPrint(
          "Lote ${lot.numberLot} atualizado com sucesso! Total de sementes germinadas: ${lot.germinatedSeedPerLot}");
    }
    setState(() {
      test.status = GerminationTest.finished;
      testRepository.updateGerminationTest(test);
    });
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
