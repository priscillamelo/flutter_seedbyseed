import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_const.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';

class Lot {
  late int id;
  late int idGerminationTest;
  late int numberLot;
  late int germinatedSeedPerLot;
  late Map<int, List<int>?> dailyCount;
  double averageIVG = 0.0;
  Map<String, double> ivgPerLot = {};

  Lot(
      {required this.idGerminationTest,
      required this.numberLot,
      required this.dailyCount,
      required this.germinatedSeedPerLot});

  void calculateIVGPerLot() {
    int repetitionsPerLot = dailyCount.values.first!.length;
    debugPrint("Número de repetições/lote: $repetitionsPerLot");

    // Iterar sobre o número de repetições
    for (int r = 0; r < repetitionsPerLot; r++) {
      String repetitionKey = "R${r + 1}"; // Nome da repetrção (R1, R2)
      List<double> repetitionDivisionPerDay = [];

      dailyCount.forEach((day, values) {
        debugPrint("DAY: $day -> VALUES: $values");
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
    debugPrint("IVG MEDIO DO LOTE $numberLot: $averageIVG");
  }

  double calculateAverageIVG() {
    double sumIVG = 0.0;
    late double averageIVG;

    ivgPerLot.forEach((key, value) {
      sumIVG += value;
    });

    averageIVG = sumIVG / ivgPerLot.length;

    return averageIVG;
  }

  // CALCULA O TEMPO MEDIO DE GERMINACOES DAS SEMENTES -> soma dos IVGs / numero de repeticoes
  void calculateAverageGerminationTime() {}

  void addDailyCount(int day, List<int> germinatedSeeds) {
    dailyCount[day] = germinatedSeeds;
  }

  static Future<int> totalGerminatedSeedPerLot(int idLot) async {
    //print("ID DO LOTE RECEBIDO: $idLot");
    int totalGerminationSeeds = 0;
    RepetitionRepository repetitionRepository = RepetitionRepository();
    List<Repetition> listRepetition =
        await repetitionRepository.getAllRepetition(idLot);
    //print("1 totalGerminationSeeds = $totalGerminationSeeds");

    for (var repetition in listRepetition) {
      //print("ID DA REPETIÇÃO: ${repetition.id}");
      //print("SEMENTES GERMINADAS DA REPETIÇÃO: ${repetition.germinatedSeeds}");
      if (repetition.germinatedSeeds > 0) {
        totalGerminationSeeds += repetition.germinatedSeeds;
        //print("2 totalGerminationSeeds = $totalGerminationSeeds");
        //print("TOTAL DE SEMENTES GERMINADAS: $totalGerminationSeeds");
      }
    }
    return totalGerminationSeeds;
  }

  Map<String, dynamic> toMap() {
    return {
      LotConst.kNUMBERLOTCOLUMN: numberLot,
      LotConst.kGERMINATEDSEEDPERLOT: germinatedSeedPerLot,
      LotConst.kIDGERMINATIONTESTFOREIGNKEY: idGerminationTest,
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

  Lot.fromMap(Map map) {
    id = map[LotConst.kIDLOTCOLUMN];
    numberLot = map[LotConst.kNUMBERLOTCOLUMN];
    germinatedSeedPerLot = map[LotConst.kGERMINATEDSEEDPERLOT];
    dailyCount = Map<int, List<int>?>.from(
      jsonDecode(map[LotConst.kDAILYCOUNTCOLUMN]).map((key, value) {
        return MapEntry(
          int.parse(key), // Converte as chaves para int
          value == null
              ? null
              : List<int>.from(value), // Converte valores para List<int>
        );
      }),
    );
    ivgPerLot = Map<String, double>.from(
      jsonDecode(map[LotConst.kIVGPERLOTCOLUMN]).map((key, value) {
        return MapEntry(
          key,
          (value as num).toDouble(), // Converte valores para List<int>
        );
      }),
    );
    idGerminationTest = map[LotConst.kIDGERMINATIONTESTFOREIGNKEY];
  }
}
