import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/dropdown_button_component.dart';
import 'package:flutter_seedbyseed/interface/widget/component/text_form_field_component.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';
import 'package:provider/provider.dart';

class AddGerminationTest extends StatelessWidget {
  const AddGerminationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste de Germinação"),
      ),
      body: const FormAddWidget(),
    );
  }
}

class FormAddWidget extends StatefulWidget {
  const FormAddWidget({super.key});

  @override
  State<FormAddWidget> createState() => _FormCustomWidgetState();
}

class _FormCustomWidgetState extends State<FormAddWidget> {
  late GerminationTestRepository testRepository;
  late LotRepository lotRepository;
  late RepetitionRepository repetitionRepository;
  final _formKey = GlobalKey<FormState>();

  final _especieController = TextEditingController();
  //final _responsavelController = TextEditingController();
  final _duracaoController = TextEditingController(text: '0');
  final _loteController = TextEditingController();
  final _repeticaoController = TextEditingController();
  final _sementesRepeticaoController = TextEditingController(text: '0');
  final _temperaturaController = TextEditingController(text: '0');
  final _contagemInicialController = TextEditingController(text: '0');
  final _contagemFinalController = TextEditingController(text: '0');
  late String materialUsed = "";
  late String substrateUsed = "";
  late List<Lot> listLot;

  @override
  Widget build(BuildContext context) {
    testRepository = Provider.of<GerminationTestRepository>(context);
    lotRepository = LotRepository();
    repetitionRepository = RepetitionRepository();

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormFieldComponent(
                      controller: _especieController,
                      textLabel: "Espécie",
                      textInputType: TextInputType.text,
                      suffixText: "",
                    ),
                    /* TextFormFieldComponent(
                    controller: _responsavelController,
                    textLabel: "Responsável",
                    textInputType: TextInputType.text,
                    suffixText: null,
                  ), */
                    TextFormFieldComponent(
                      controller: _duracaoController,
                      textLabel: "Duração",
                      textInputType: TextInputType.number,
                      suffixText: "Dias",
                    ),
                    TextFormFieldComponent(
                      controller: _loteController,
                      textLabel: "Lote",
                      textInputType: TextInputType.number,
                      suffixText: "",
                    ),
                    TextFormFieldComponent(
                      controller: _repeticaoController,
                      textLabel: "Repetição",
                      textInputType: TextInputType.number,
                      suffixText: "Por Lote",
                    ),
                    TextFormFieldComponent(
                      controller: _sementesRepeticaoController,
                      textLabel: "Sementes",
                      textInputType: TextInputType.number,
                      suffixText: "Por Repetição",
                    ),
                    TextFormFieldComponent(
                      controller: _temperaturaController,
                      textLabel: "Temperatura",
                      textInputType: TextInputType.text,
                      /* .numberWithOptions(
                      signed: true,
                      decimal: true,
                    ), */
                      suffixText: "ºC",
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: TextFormFieldComponent(
                              controller: _contagemInicialController,
                              textLabel: "Contagem Inicial",
                              textInputType: TextInputType.number,
                              suffixText: "",
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextFormFieldComponent(
                              controller: _contagemFinalController,
                              textLabel: "Contagem Final",
                              textInputType: TextInputType.number,
                              suffixText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonComponent(
                      typeEnum: 'Material',
                      selectedMaterialOrSubstrate: (material) {
                        setState(() {
                          materialUsed = material;
                        });
                      },
                    ),
                    DropdownButtonComponent(
                      typeEnum: 'Substrate',
                      selectedMaterialOrSubstrate: (substrate) {
                        setState(() {
                          substrateUsed = substrate;
                          //debugPrint(substrateUsed);
                        });
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                GerminationTest germinationTest =
                                    GerminationTest(
                                        species: _especieController.text,
                                        materialUsed: materialUsed,
                                        substratoUsed: substrateUsed,
                                        temperature:
                                            _temperaturaController.text,
                                        duration:
                                            int.parse(_duracaoController.text),
                                        firstCount: int.parse(
                                            _contagemInicialController.text),
                                        lastCount: int.parse(
                                            _contagemFinalController.text),
                                        totalSeeds: int.parse(
                                                _repeticaoController.text) *
                                            int.parse(
                                                _sementesRepeticaoController
                                                    .text));

                                Future<int> idFuture = testRepository
                                    .addGerminationTest(germinationTest);
                                int idGerminationTest = await idFuture;

                                //debugPrint(idGerminationTest.toString());

                                listLot = List<Lot>.generate(
                                    int.parse(_loteController.text), (index) {
                                  return Lot(
                                      idGerminationTest: idGerminationTest,
                                      numberLot: index + 1);
                                });

                                List<int> listIdLot = [];

                                for (var lot in listLot) {
                                  idFuture = lotRepository.addLot(lot);
                                  int id = await idFuture;
                                  listIdLot.add(id);
                                }

                                int repetitionCount =
                                    int.parse(_repeticaoController.text);

                                for (int i = 0; i < listIdLot.length; i++) {
                                  for (int j = 0; j < repetitionCount; j++) {
                                    Repetition repetition = Repetition(
                                        lotId: listIdLot[i],
                                        seedsTotal: int.parse(
                                            _sementesRepeticaoController.text),
                                        germinatedSeeds: 0);
                                    idFuture = repetitionRepository
                                        .addRepetition(repetition);
                                    int id = await idFuture;

                                    debugPrint(
                                        "ID da repetição: ${id.toString()}");
                                    debugPrint(
                                        "ID do lote: ${listIdLot[i].toString()}");
                                  }

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${germinationTest.species} cadastrado!')),
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "Cadastrar Teste",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ])
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
