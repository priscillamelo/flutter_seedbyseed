import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/repetition.dart';
import 'package:flutter_seedbyseed/persistence/constants/lot_const.dart';
import 'package:flutter_seedbyseed/persistence/repository/repetition_repository.dart';

class Lot {
  int? id; // Pode ser nulo até ser salvo no banco
  final int idGerminationTest;
  final int numberLot;
  int germinatedSeedPerLot;
  final int totalSeeds;
  late Map<int, List<int>?> dailyCount;
  double averageIVG;
  Map<String, double> ivgPerLot;

  Lot({
    this.id,
    required this.idGerminationTest,
    required this.numberLot,
    required this.dailyCount,
    required this.totalSeeds,
    this.germinatedSeedPerLot = 0,
    this.averageIVG = 0.0,
    Map<String, double>? ivgPerLot,
  }) : ivgPerLot = ivgPerLot ?? {};

  void calculateIVGPerLot() {
    int repetitionsPerLot = dailyCount.values.first!.length;
    //debugPrint("Número de repetições/lote: $repetitionsPerLot");

    // Iterar sobre o número de repetições
    for (int r = 0; r < repetitionsPerLot; r++) {
      String repetitionKey = "R${r + 1}"; // Nome da repetição (R1, R2)
      List<double> repetitionDivisionPerDay = [];

      dailyCount.forEach((day, values) {
        // Dividir o valor (sementes germinadas) pela a chave (dia) e adicionar ao resultado
        double resultado = values![r] / day;

        // Adicionar o resultado da divisao, fixando apenas 2 casas decimais apos a virgula, na lista do tipo double
        repetitionDivisionPerDay
            .add(double.parse(resultado.toStringAsFixed(2)));
      });

      debugPrint(
          "RESULTADO DA DIVISAO R${r + 1} -> sementeGerminada/dia: $repetitionDivisionPerDay");

      ivgPerLot[repetitionKey] = double.parse(repetitionDivisionPerDay
          .reduce((sum, value) => sum + value)
          .toStringAsFixed(2));
    }

    averageIVG = calculateAverageIVG();
    debugPrint("IVG Per Lote: $ivgPerLot");
    debugPrint("IVG MEDIO DO LOTE $numberLot: $averageIVG");
  }

  // CALCULA O TEMPO MEDIO DE GERMINACOES DAS SEMENTES -> soma dos IVGs / numero de repeticoes
  double calculateAverageIVG() {
    double sumIVG = 0.0;
    late double averageIVG;

    ivgPerLot.forEach((key, value) {
      sumIVG += value;
    });

    averageIVG = sumIVG / ivgPerLot.length;

    return double.parse(averageIVG.toStringAsFixed(2));
  }

  Future<void> calculateTotalGerminatedSeedPerLot() async {
    int totalGerminationSeeds = 0;
    RepetitionRepository repetitionRepository = RepetitionRepository();
    List<Repetition> listRepetition =
        await repetitionRepository.getAllRepetition(id);

    for (var repetition in listRepetition) {
      if (repetition.germinatedSeeds > 0) {
        totalGerminationSeeds += repetition.germinatedSeeds;
      }
    }
    germinatedSeedPerLot = totalGerminationSeeds;
  }

  Future<List<double>> calculatePercGerminatedSeedsPerRepetition() async {
    RepetitionRepository repetitionRepository = RepetitionRepository();
    List<Repetition> listRepetition =
        await repetitionRepository.getAllRepetition(id);
    List<int> listGerminatedSeeds = [];
    List<double> percGerminatedSeeds = [];

    for (var repetition in listRepetition) {
      // Verifica se a repetição tem sementes germinadas
      if (repetition.germinatedSeeds > 0) {
        // Adiciona o número de sementes germinadas à lista
        listGerminatedSeeds.add(repetition.germinatedSeeds);
        // Calcula o percentual de sementes germinadas para cada repetição
        double perc =
            (repetition.germinatedSeeds / repetition.seedsTotal) * 100;
        percGerminatedSeeds.add(perc);
      }
    }

    return percGerminatedSeeds;
  }

  Future<double> calculatePercAverageGerminatedSeeds() async {
    List<double> listPercGerminatedSeeds =
        await calculatePercGerminatedSeedsPerRepetition();
    if (listPercGerminatedSeeds.isEmpty) return 0.0;

    // Calcula a média do percentual de sementes germinadas
    double averagePercGerminatedSeeds =
        listPercGerminatedSeeds.reduce((sum, value) => sum + value) /
            listPercGerminatedSeeds.length;

    return double.parse(averagePercGerminatedSeeds.toStringAsFixed(2));
  }

  Map<String, dynamic> toMap() {
    return {
      LotConst.kNUMBERLOTCOLUMN: numberLot,
      LotConst.kTOTALSEEDPERLOT: totalSeeds,
      LotConst.kGERMINATEDSEEDPERLOT: germinatedSeedPerLot,
      LotConst.kIDGERMINATIONTESTFOREIGNKEY: idGerminationTest,
      LotConst.kAVERAGEIVGCOLUMN: averageIVG,
      LotConst.kDAILYCOUNTCOLUMN: jsonEncode(
        dailyCount.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      ), // Converte as chaves de int para String,
      LotConst.kIVGPERLOTCOLUMN: jsonEncode(
        ivgPerLot.map(
          (key, value) => MapEntry(key, value),
        ),
      ),
    };
  }

  Lot.fromMap(Map map)
      : id = map[LotConst.kIDLOTCOLUMN],
        numberLot = map[LotConst.kNUMBERLOTCOLUMN],
        totalSeeds = map[LotConst.kTOTALSEEDPERLOT],
        germinatedSeedPerLot = map[LotConst.kGERMINATEDSEEDPERLOT],
        averageIVG = map[LotConst.kAVERAGEIVGCOLUMN],
        dailyCount = Map<int, List<int>?>.from(
          jsonDecode(map[LotConst.kDAILYCOUNTCOLUMN])
              .map((String key, dynamic value) {
            return MapEntry(
                int.parse(key), value == null ? null : List<int>.from(value));
          }),
        ),
        ivgPerLot = Map<String, double>.from(
          jsonDecode(map[LotConst.kIVGPERLOTCOLUMN])
              .map((String key, dynamic value) {
            return MapEntry(key, (value as num).toDouble());
          }),
        ),
        idGerminationTest = map[LotConst.kIDGERMINATIONTESTFOREIGNKEY];
}
