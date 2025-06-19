import 'package:flutter/material.dart';

class SliderComponent extends StatefulWidget {
  final double valueStart;
  final double valueMax;
  final void Function(double) totalGerminatedSeeds;

  const SliderComponent({
    super.key,
    required this.valueStart,
    required this.valueMax,
    required this.totalGerminatedSeeds,
  });

  @override
  State<SliderComponent> createState() => _SliderComponentState();
}

class _SliderComponentState extends State<SliderComponent> {
  late double valueGerminationSeed;
  late double valueMax;

  @override
  void initState() {
    super.initState();
    //debugPrint("Valor inicial: ${widget.valueStart}");
    // Inicializa o valor com o valor inicial vindo do widget
    valueGerminationSeed = widget.valueStart;
    valueMax = widget.valueMax;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isEnabled = valueMax > 0.0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: isEnabled ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
        inactiveTrackColor: isEnabled ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.onSurface.withValues(alpha: 0.1),
        thumbColor: isEnabled ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
        trackHeight: 4.0,
        overlayColor: colorScheme.primary.withAlpha(32),
        valueIndicatorColor: colorScheme.primary,
        inactiveTickMarkColor: Colors.grey.shade400,
        activeTickMarkColor: colorScheme.primary,
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.5),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Slider(
        value: valueGerminationSeed,
        min: 0.0,
        max: valueMax,
        label: "${valueGerminationSeed.toInt()}",
        divisions: isEnabled ? valueMax.toInt() : 0,
        onChanged: isEnabled
            ? (value) {
                setState(() {
                  valueGerminationSeed = value;
                  widget.totalGerminatedSeeds(valueGerminationSeed);
                });
              }
            : null,
      ),
    );
  }
}
