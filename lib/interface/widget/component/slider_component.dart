import 'package:flutter/material.dart';

class SliderComponent extends StatefulWidget {
  final int valueMax;
  final Function(double) totalGerminatedSeeds;
  const SliderComponent({
    super.key,
    required this.valueMax,
    required this.totalGerminatedSeeds,
  });

  @override
  State<SliderComponent> createState() => _SliderComponentState();
}

class _SliderComponentState extends State<SliderComponent> {
  double _value = 0.0;
  late double seedsTotal;
  @override
  Widget build(BuildContext context) {
    seedsTotal = widget.valueMax.toDouble();
    print(seedsTotal);
    return Slider(
      min: 0.0,
      max: seedsTotal,
      value: _value,
      label: '${_value.toInt()}',
      divisions: seedsTotal.toInt(),
      onChanged: (value) {
        setState(() {
          _value = value;
          widget.totalGerminatedSeeds(_value);
        });
      },
    );
  }
}
