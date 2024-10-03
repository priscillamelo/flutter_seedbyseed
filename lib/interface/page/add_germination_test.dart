import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/text_form_field_component.dart';
import 'package:flutter_seedbyseed/route/routes.dart';

class AddGerminationTest extends StatelessWidget {
  const AddGerminationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seed By Seed"),
      ),
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
  final _contagemInicialController = TextEditingController();
  final _contagemFinalController = TextEditingController();

  List<int> lotes = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Teste de Germinação",
                      style: TextStyle(fontSize: 36),
                    ),
                    TextFormFieldComponent(
                      controller: _especieController,
                      textLabel: "Espécie",
                      textInputType: TextInputType.text,
                    ),
                    TextFormFieldComponent(
                      controller: _responsavelController,
                      textLabel: "Responsável",
                      textInputType: TextInputType.text,
                    ),
                    TextFormFieldComponent(
                      controller: _duracaoController,
                      textLabel: "Duração",
                      textInputType: TextInputType.number,
                    ),
                    /* ListView.builder(
                      itemCount: lotes.length,
                      itemBuilder: (context, index) {
                        return TextFormField(
                          controller: _loteController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Lote'),
                          onChanged: (value) {
                            setState(() {
                              lotes[index]['lote'] = int.parse(value);
                            });
                          },
                        );
                      },
                    ), */
                    TextFormFieldComponent(
                      controller: _duracaoController,
                      textLabel: "Lote",
                      textInputType: TextInputType.number,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 48,
                              ),
                            ),
                          ),
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
                            Navigator.pushNamed(context,
                                PageRoutes.kADD_REPETITIONGERMINATIONTEST);
                          },
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 48,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Prosseguir",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
