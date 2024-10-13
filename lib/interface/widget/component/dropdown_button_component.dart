import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/text_form_field_component.dart';
import 'package:flutter_seedbyseed/model/germinationTest/enum/material_enum.dart';
import 'package:flutter_seedbyseed/model/germinationTest/enum/substrate_enum.dart';

class DropdownButtonComponent extends StatefulWidget {
  final String typeEnum;
  const DropdownButtonComponent({super.key, required this.typeEnum});

  @override
  State<DropdownButtonComponent> createState() =>
      _DropdownButtonComponentState();
}

class _DropdownButtonComponentState extends State<DropdownButtonComponent> {
  MaterialEnum? _selectedMaterial;
  SubstrateEnum? _selectedSubstrate;
  //String? _otherMaterial;
  final TextEditingController otherMaterial = TextEditingController();

  bool _otherSelected = false;

  List<DropdownMenuItem<dynamic>> _buildDropdownMenuMaterials() {
    List<DropdownMenuItem<dynamic>> items = MaterialEnum.values.map((material) {
      return DropdownMenuItem<dynamic>(
        value: material,
        child: Text(material.description),
      );
    }).toList();

    items.add(
      const DropdownMenuItem<String>(
        value: 'Outro',
        child: Text('Outro'),
      ),
    );

    return items;
  }

  List<DropdownMenuItem<dynamic>> _buildDropdownMenuSubstrates() {
    List<DropdownMenuItem<dynamic>> items =
        SubstrateEnum.values.map((substrate) {
      return DropdownMenuItem<dynamic>(
        value: substrate,
        child: Text(substrate.description),
      );
    }).toList();

    items.add(
      const DropdownMenuItem<String>(
        value: 'Outro',
        child: Text('Outro'),
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    String typeEnum = widget.typeEnum;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<dynamic>(
          value: _otherSelected
              ? 'Outro'
              : (typeEnum == 'Material'
                  ? _selectedMaterial
                  : _selectedSubstrate),
          hint: Text(
            typeEnum == 'Material'
                ? 'Selecione um material'
                : 'Selecione um substrato',
          ),
          items: typeEnum == 'Material'
              ? _buildDropdownMenuMaterials()
              : _buildDropdownMenuSubstrates(),
          onChanged: (dynamic newValue) {
            setState(() {
              if (newValue == 'Outro') {
                _otherSelected = true;
                _selectedMaterial = null;
                _selectedSubstrate = null;
              } else {
                _otherSelected = false;
                typeEnum == 'Material'
                    ? _selectedMaterial = newValue
                    : _selectedSubstrate = newValue;
              }
            });
          },
        ),
        const SizedBox(height: 20),
        _otherSelected
            ? TextFormFieldComponent(
                textLabel: typeEnum == 'Material' ? 'Material' : 'Substrato',
                controller: otherMaterial,
                textInputType: TextInputType.text,
                suffixText: null)

            /* TextField(
              decoration:
                  const InputDecoration(labelText: 'Digite o material'),
              onChanged: (value) {
                setState(() {
                  _otherMaterial = value;
                });
              },
            ) */
            : Container(),
      ],
    );
  }
}
