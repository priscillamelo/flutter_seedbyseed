import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';

class AddGerminatedSeeds extends StatefulWidget {
  const AddGerminatedSeeds({super.key});

  @override
  State<AddGerminatedSeeds> createState() => _AddSeedGerminationState();
}

class _AddSeedGerminationState extends State<AddGerminatedSeeds> {
  //late List<TextEditingController> germinatedSeedsControllers;

  /*  @override
  void dispose() {
    // Limpa os controladores ao encerrar a página
    for (var controller in germinatedSeedsControllers) {
      controller.dispose();
    }
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as GerminationTest;

    /* germinatedSeedsControllers = arg.repetition.keys.map((key) {
      return TextEditingController(text: key.toString());
    }).toList(); */

    // debugPrint(arg.repetition.toString());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Sementes Germinadas'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Informe a quantidade de sementes germinadas"),
                Text(arg.species),
                /*  Expanded(
                  child: ListView.builder(
                      itemCount: arg.repetition.keys.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: TextFormFieldComponent(
                              textLabel: 'Repetição ${index + 1}',
                              controller: germinatedSeedsControllers[index],
                              textInputType: TextInputType.number,
                              suffixText: "sementes germinadas"),
                        );
                      }),
                ), */
                ElevatedButton(
                  onPressed: () {
                    /* List<int> germinatedSeeds = [];
                    for (var controller in germinatedSeedsControllers) {
                      germinatedSeeds.add(int.parse(controller.text));
                      debugPrint(controller.text);
                    } */
                  },
                  child: const Text("Atualizar dados"),
                ),
              ],
            ),
          ),
        ));
  }
}
