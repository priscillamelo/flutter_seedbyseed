import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/floating_button_component.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  GerminationTestRepository testRepository = GerminationTestRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: testRepository.getAllGerminationTest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].species),
                    );
                  },
                ),
              );
            } else {
              return const TabProgressNoData();
            }
          }),
      floatingActionButton: const FloatingButtonSmallComponent(),
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
