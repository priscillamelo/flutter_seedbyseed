import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/infra/config/notification_local_service.dart';
import 'package:flutter_seedbyseed/interface/widget/component/dropdown_button_component.dart';
import 'package:flutter_seedbyseed/interface/widget/component/text_form_field_component.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/domain/model/repetition.dart';
import 'package:flutter_seedbyseed/persistence/repository/germination_test_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/repetition_repository.dart';
import 'package:flutter_seedbyseed/infra/config/verify_date.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddGerminationTest extends StatefulWidget {
  final GerminationTest? testToEdit;

  const AddGerminationTest({super.key, this.testToEdit});

  @override
  State<AddGerminationTest> createState() => _AddGerminationTestState();
}

class _AddGerminationTestState extends State<AddGerminationTest> {
  bool _isActiveNotification = true;

  bool getStatusNotification() {
    return _isActiveNotification;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.testToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          isEditing
              ? "Editar Teste de Germinação"
              : "Cadastro de Teste de Germinação",
          maxLines: 1,
          minFontSize: 10,
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(_isActiveNotification
                ? Icons.notifications_active
                : Icons.notifications_off),
            onPressed: () {
              setState(() {
                _isActiveNotification = !_isActiveNotification;
              });
            },
          ),
        ],
      ),
      body: FormAddWidget(
        statusNotification: getStatusNotification(),
        testToEdit: widget.testToEdit,
      ),
    );
  }
}

class FormAddWidget extends StatefulWidget {
  final bool statusNotification;
  final GerminationTest? testToEdit;
  const FormAddWidget(
      {super.key, required this.statusNotification, this.testToEdit});

  @override
  State<FormAddWidget> createState() => _FormCustomWidgetState();
}

class _FormCustomWidgetState extends State<FormAddWidget> {
  late GerminationTestRepository testRepository;
  late LotRepository lotRepository;
  late RepetitionRepository repetitionRepository;
  final _formKey = GlobalKey<FormState>();

  final _especieController = TextEditingController();
  final _loteController = TextEditingController();
  final _repeticaoController = TextEditingController();
  final _sementesRepeticaoController = TextEditingController();
  final _temperaturaController = TextEditingController();
  final _contagemInicialController = TextEditingController();
  final _contagemFinalController = TextEditingController();
  late String materialUsed = "";
  late String substrateUsed = "";

  @override
  void initState() {
    super.initState();
    final test = widget.testToEdit;
    if (test != null) {
      _especieController.text = test.species;
      _temperaturaController.text = test.temperature;
      _contagemInicialController.text = test.firstCount.toString();
      _contagemFinalController.text = test.lastCount.toString();
      materialUsed = test.materialUsed;
      substrateUsed = test.substratoUsed;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    testRepository = Provider.of<GerminationTestRepository>(context);
    lotRepository = LotRepository();
    repetitionRepository = RepetitionRepository();
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.testToEdit != null;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection("Identificação", [
                      TextFormFieldComponent(
                        controller: _especieController,
                        textLabel: "Espécie",
                        textInputType: TextInputType.text,
                        icon: Icons.eco_outlined,
                      ),
                    ]),
                    _buildSection("Especificações", [
                      TextFormFieldComponent(
                        controller: _loteController,
                        textLabel: "Lotes",
                        textInputType: TextInputType.number,
                        icon: FontAwesomeIcons.boxesStacked,
                      ),
                      TextFormFieldComponent(
                        controller: _repeticaoController,
                        textLabel: "Repetições por lote",
                        textInputType: TextInputType.number,
                        icon: Icons.repeat,
                      ),
                      TextFormFieldComponent(
                        controller: _sementesRepeticaoController,
                        textLabel: "Sementes por repetição",
                        textInputType: TextInputType.number,
                        icon: Icons.grain_outlined,
                      ),
                      TextFormFieldComponent(
                        controller: _temperaturaController,
                        textLabel: "Temperatura (ºC)",
                        textInputType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        icon: Icons.thermostat_outlined,
                      ),
                    ]),
                    _buildSection("Contagens", [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormFieldComponent(
                              controller: _contagemInicialController,
                              textLabel: "Contagem Inicial",
                              textInputType: TextInputType.number,
                              icon: FontAwesomeIcons.hourglassStart,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormFieldComponent(
                              controller: _contagemFinalController,
                              textLabel: "Contagem Final",
                              textInputType: TextInputType.number,
                              icon: FontAwesomeIcons.hourglassEnd,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    _buildSection("Materiais", [
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
                          });
                        },
                      ),
                    ]),
                    const SizedBox(height: 32),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  GerminationTest germinationTest =
                                      _instantiateGerminationTest();

                                  if (isEditing) {
                                    germinationTest.id = widget.testToEdit!.id;
                                    await testRepository
                                        .updateGerminationTest(germinationTest);
                                  } else {
                                    germinationTest.id = await testRepository
                                        .addGerminationTest(germinationTest);
                                    if (germinationTest.id != null) {
                                      final listIdLot = await _instantiateLots(
                                          germinationTest.id!);
                                      await _instantiateRepetitions(listIdLot);
                                    }
                                  }

                                  if (widget.statusNotification) {
                                    await _scheduleNotification(
                                        germinationTest);
                                  }

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          content: Text(isEditing
                                              ? '${germinationTest.species} atualizado!'
                                              : '${germinationTest.species} cadastrado!')),
                                    );

                                    Navigator.pop(context);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                isEditing
                                    ? "Salvar Alterações"
                                    : "Cadastrar Teste",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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

  GerminationTest _instantiateGerminationTest() {
    final createdDate = widget.testToEdit?.createdAt ??
        VerifyDate.normalizeDayMonth(DateTime.now());

    final int repetitionCount = int.parse(_repeticaoController.text);
    final int loteCount = int.parse(_loteController.text);

    final totalSeedsTest =
        (int.parse(_sementesRepeticaoController.text) * repetitionCount) *
            loteCount;

    return GerminationTest(
      species: _especieController.text,
      materialUsed: materialUsed,
      substratoUsed: substrateUsed,
      temperature: _temperaturaController.text,
      createdAt: createdDate,
      firstCount: int.parse(_contagemInicialController.text),
      lastCount: int.parse(_contagemFinalController.text),
      totalSeeds: totalSeedsTest,
    );
  }

  Future<List<int>> _instantiateLots(int idGerminationTest) async {
    final int days = int.parse(_contagemFinalController.text);
    final int repetitionCount = int.parse(_repeticaoController.text);
    final int loteCount = int.parse(_loteController.text);
    final int totalSeedsPerLot =
        int.parse(_sementesRepeticaoController.text) * repetitionCount;

    final List<Lot> lots = List.generate(loteCount, (index) {
      return Lot(
        idGerminationTest: idGerminationTest,
        numberLot: index + 1,
        dailyCount: {
          for (int i = 1; i <= days; i++)
            i: List<int>.filled(repetitionCount, 0),
        },
        totalSeeds: totalSeedsPerLot,
      );
    });

    List<int> lotIds = [];
    for (final lot in lots) {
      final id = await lotRepository.addLot(lot);
      lotIds.add(id);
    }

    return lotIds;
  }

  Future<void> _instantiateRepetitions(List<int> lotIds) async {
    final int repetitionCount = int.parse(_repeticaoController.text);
    final int seedsPerRepetition = int.parse(_sementesRepeticaoController.text);

    for (final lotId in lotIds) {
      for (int i = 0; i < repetitionCount; i++) {
        final repetition = Repetition(
          lotId: lotId,
          seedsTotal: seedsPerRepetition,
        );
        await repetitionRepository.addRepetition(repetition);
      }
    }
  }

  Future<void> _scheduleNotification(GerminationTest test) async {
    await NotificationLocalService().requestExactAlarmPermission(context);
    final DateTime firstCountDate = test.calculateCountDate(test.firstCount);

    if (test.id != null) {
      await NotificationLocalService().scheduleGerminationNotification(
        testId: test.id!,
        date: firstCountDate,
        seedName: test.species,
      );
    }
  }
}
