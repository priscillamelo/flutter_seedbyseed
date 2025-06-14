import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/export_excel.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:provider/provider.dart';

class DetailsGerminationTest extends StatefulWidget {
  const DetailsGerminationTest({super.key});

  @override
  State<DetailsGerminationTest> createState() => _DetailsGerminationTestState();
}

class _DetailsGerminationTestState extends State<DetailsGerminationTest> {
  late LotRepository lotRepository;

  @override
  Widget build(BuildContext context) {
    lotRepository = Provider.of<LotRepository>(context);
    final GerminationTest testArgument =
        ModalRoute.of(context)!.settings.arguments as GerminationTest;

    Future<List<Lot>> futureListLot = lotRepository.getAllLots(testArgument.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Teste de Germinação"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: futureListLot,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Espécie: ${testArgument.species}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "Tempo Médio de Germinação do Lote ${snapshot.data![index].numberLot}: ${snapshot.data![index].averageIVG}"),
                              ],
                            ),
                          );
                        }),
                  ]);
            } else {
              return const Center(
                child: Text('Nenhuma repetição cadastrada'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: "exportarTesteGerminacao",
        tooltip: "Exportar dados do Teste de Germinação",
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          List<Lot> listLot = await  futureListLot;
          //TODO: CRIAR A FUNÇÃO DE EXPORTAR O TESTE DE GERMINAÇÃO EM .CSV
          exportarExcel(listLot);
        },
        child: Icon(
          Icons.download_rounded,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );

  }
}
