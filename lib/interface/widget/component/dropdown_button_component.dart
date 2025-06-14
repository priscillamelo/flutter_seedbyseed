import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/text_form_field_component.dart';
import 'package:flutter_seedbyseed/domain/enum/material_enum.dart';
import 'package:flutter_seedbyseed/domain/enum/substrate_enum.dart';

class DropdownButtonComponent extends StatefulWidget {
  final String typeEnum;
  final dynamic Function(String) selectedMaterialOrSubstrate;

  const DropdownButtonComponent({
    super.key,
    required this.typeEnum,
    required this.selectedMaterialOrSubstrate,
  });

  @override
  State<DropdownButtonComponent> createState() =>
      _DropdownButtonComponentState();
}

class _DropdownButtonComponentState extends State<DropdownButtonComponent> {
  late List<DropdownMenuItem<dynamic>> listItems;
  late String dropdownValue = "";
  final TextEditingController otherMaterial = TextEditingController();
  bool _otherSelected = false;

  @override
  Widget build(BuildContext context) {
    String? typeEnum = widget.typeEnum;
    listItems = getListMaterialOrSubstrate(typeEnum);
    return Column(
      children: [
        DropdownButton<dynamic>(
          isExpanded: true,
          value: (dropdownValue.isEmpty) ? null : dropdownValue,
          hint: Text(
            typeEnum == 'Material'
                ? 'Selecione um material'
                : 'Selecione um substrato',
          ),
          items: listItems,
          onChanged: (newValue) {
            setState(() {
              dropdownValue = newValue;
              if (newValue != 'Outro') {
                typeEnum == 'Material'
                    ? widget.selectedMaterialOrSubstrate(newValue)
                    : widget.selectedMaterialOrSubstrate(newValue);

                _otherSelected = false;
              } else {
                _otherSelected = true;

                //otherMaterial.text = newValue;
                widget.selectedMaterialOrSubstrate(otherMaterial.text);
              }
            });
          },

          /* TextField(
                  decoration:
                      const InputDecoration(labelText: 'Digite o material'),
                  onChanged: (value) {
                    setState(() {
                      _otherMaterial = value;
                    });
                  },
                ) */
        ),
        _otherSelected
            ? Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: TextFormFieldComponent(
                    textLabel: typeEnum == 'Material'
                        ? 'Digite o material'
                        : 'Digite o substrato',
                    controller: otherMaterial,
                    textInputType: TextInputType.text,
                    suffixText: ""),
              )
            : Container(),
      ],
    );
  }
}

List<DropdownMenuItem<dynamic>> getListMaterialOrSubstrate(String type) {
  List<DropdownMenuItem<dynamic>> items;

  if (type == 'Material') {
    items = MaterialEnum.values.map((material) {
      return DropdownMenuItem<dynamic>(
        value: material.description,
        child: Text(material.description),
      );
    }).toList();
  } else {
    items = SubstrateEnum.values.map((substrate) {
      return DropdownMenuItem<dynamic>(
        value: substrate.description,
        child: Text(substrate.description),
      );
    }).toList();
  }

  items.add(
    const DropdownMenuItem<String>(
      value: 'Outro',
      child: Text('Outro'),
    ),
  );

  return items;
}
