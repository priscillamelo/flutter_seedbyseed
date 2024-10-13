import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/dropdown_button_component.dart';
import 'package:flutter_seedbyseed/interface/widget/component/text_form_field_component.dart';

class AddGerminationTest extends StatelessWidget {
  const AddGerminationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste de Germinação"),
      ),
      persistentFooterButtons: [
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
              onPressed: () {
                /*  if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Teste cadastrado!')),
                                  );
                                  Navigator.pop(context);
                                } */
                Navigator.pop(context);
              },
              child: const Text(
                "Cadastrar Teste",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ],
      body: const FormCustomWidget(),
    );
  }
}

class FormCustomWidget extends StatefulWidget {
  const FormCustomWidget({super.key});

  @override
  State<FormCustomWidget> createState() => _FormCustomWidgetState();
}

class _FormCustomWidgetState extends State<FormCustomWidget> {
  final _formKey = GlobalKey<FormState>();

  final _especieController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _loteController = TextEditingController();
  final _repeticaoController = TextEditingController();
  final _sementesRepeticaoController = TextEditingController();
  final _temperaturaController = TextEditingController();

  final _contagemInicialController = TextEditingController();
  final _contagemFinalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: /* LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    
                  ),
                );
              },
            ), */
                SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormFieldComponent(
                    controller: _especieController,
                    textLabel: "Espécie",
                    textInputType: TextInputType.text,
                    suffixText: null,
                  ),
                  TextFormFieldComponent(
                    controller: _responsavelController,
                    textLabel: "Responsável",
                    textInputType: TextInputType.text,
                    suffixText: null,
                  ),
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
                    suffixText: null,
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
                    textInputType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
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
                            suffixText: null,
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
                            suffixText: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const DropdownButtonComponent(
                    typeEnum: 'Material',
                  ),
                  const DropdownButtonComponent(
                    typeEnum: 'Substrate',
                  ),
                  /* Row(
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
                        onPressed: () {
                          /*  if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Teste cadastrado!')),
                                  );
                                  Navigator.pop(context);
                                } */
                        },
                        child: const Text(
                          "Cadastrar Teste",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ), */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
