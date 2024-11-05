import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/floating_button_component.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:provider/provider.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  @override
  Widget build(BuildContext context) {
    GerminationTestRepository testRepository =
        Provider.of<GerminationTestRepository>(context);
    return FutureBuilder(
        future: testRepository.getAllGerminationTest(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var data = snapshot.data;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: ListTile(
                        title: Text(data![index].species),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TODO: CRIAR UM COMPONENT DE TEXT()
                            Flexible(
                                child: Text(
                                    "Temperatura: ${data[index].temperature}")),
                            const Flexible(child: Text("Dia Atual: ${1}")),
                            Flexible(
                                child: Text(
                                    "Duração Total: ${data[index].duration}")),
                            Flexible(
                                child: Text(
                                    "Contagem Inicial: ${data[index].firstCount}")),
                            Flexible(
                                child: Text(
                                    "Contagem Final: ${data[index].lastCount}")),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: const FloatingButtonSmallComponent(),
            );
          } else {
            return const TabProgressNoData();
          }
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
