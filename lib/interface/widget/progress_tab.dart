import 'package:flutter/material.dart';
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
                    return GerminationTestCard(
                      germinationTest: data[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageRoutes.kADD_GERMINATEDSEEDS,
                          arguments: data[index],
                        );
                      },
                      onLongPress: () => _confirmDeleteGerminationTest(
                          context, data[index].id),
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

  void _confirmDeleteGerminationTest(
      BuildContext context, int germinationTestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remover teste"),
        content: const Text("Deseja remover o teste de germinação?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                testRepository.deleteGerminationTest(germinationTestId);
              });
              Navigator.pop(context);
            },
            child: const Text("Remover"),
          ),
        ],
      ),
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
