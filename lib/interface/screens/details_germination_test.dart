import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/export_excel.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Erro ao carregar os dados.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
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
                          final lot = snapshot.data![index];
                          return ListTile(
                            title: Badge(
                              label: Text("Dados do Lote ${lot.numberLot}"),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "IVG de cada Repetição: ${lot.ivgPerLot}"),
                                    Text(
                                        "Tempo Médio de IVG : ${lot.averageIVG}"),
                                    FutureBuilder<List<double>>(
                                      future: lot
                                          .calculatePercGerminatedSeedsPerRepetition(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text(
                                              "Carregando porcentagem por repetição...");
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Erro: ${snapshot.error}");
                                        } else {
                                          return Text(
                                            "Percentual de sementes germinadas de cada Repetição: ${snapshot.data!.map((e) => e.toStringAsFixed(2)).join(', ')}%",
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder<double>(
                                      future: lot
                                          .calculatePercAverageGerminatedSeeds(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text(
                                              "Carregando média de germinação...");
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Erro: ${snapshot.error}");
                                        } else {
                                          return Text(
                                            "Média do percentual de sementes germinadas: ${snapshot.data!.toStringAsFixed(2)}%",
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                            ),
                          );
                        })
                  ]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: "exportarTesteGerminacao",
        tooltip: "Exportar dados do Teste de Germinação",
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          List<Lot> listLot = await futureListLot;
          //TODO: CRIAR A FUNÇÃO DE EXPORTAR O TESTE DE GERMINAÇÃO EM .CSV
          exportarExcel(listLot);
        },
        child: Icon(
          FontAwesomeIcons.fileExcel,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
