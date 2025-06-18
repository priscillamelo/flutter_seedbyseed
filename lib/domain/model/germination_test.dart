import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/enum/status_germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/persistence/constants/germination_test_const.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:intl/intl.dart';

class GerminationTest {
  static const inProgress = 'in_progress';
  static const finished = 'finished';

  late int id;
  late String species;
  late String materialUsed;
  late String substratoUsed;
  late String temperature;
  late int firstCount;
  late int lastCount;
  late int totalSeeds;
  late final String createdAt;
  int germinatedSeeds = 0;
  int currentDay = 0;
  String status = StatusGerminationTest.inProgress.statusValue;

  GerminationTest({
    required this.species,
    required this.materialUsed,
    required this.substratoUsed,
    required this.temperature,
    required this.createdAt,
    required this.firstCount,
    required this.lastCount,
    required this.totalSeeds,
  });

  // Calcula o dia da primeira contagem
  DateTime calculateCountDate(int count) {
    final DateTime createdAtDate =
        DateFormat('dd/MM/yyyy', 'pt_BR').parse(createdAt);
    final DateTime countDate = createdAtDate.add(Duration(days: count - 1));

    debugPrint(
        "Data da primeira contagem: $countDate, criada em: $createdAtDate");

    return countDate;
  }

  int calculateDifferenceDays(DateTime date) {
    final DateTime today = DateTime.now();
    final int difference = today.difference(date).inDays;

    return difference;
  }

  // Calcula o dia atual com base na diferença de dias entre hoje e a data da primeira contagem
  void updateCurrentDay(DateTime firstCountDate) {
    final DateTime createdAtDate =
        DateFormat('dd/MM/yyyy', 'pt_BR').parse(createdAt);
    final int difference = calculateDifferenceDays(createdAtDate);

    currentDay = difference + 1;
  }

  // Verfica se hoje é o dia da primeira contagem
  bool verifyIsFirstCountAvailable() {
    final DateTime today = DateTime.now();
    final DateTime firstCountDate = calculateCountDate(firstCount);
    final DateTime lastCountDate = calculateCountDate(lastCount);
    final bool isFirstCountDayAvailable =
        today.isAfter(firstCountDate) || today.isAtSameMomentAs(firstCountDate);
    final bool isLastCountDayAvailable =
        today.isBefore(lastCountDate) || today.isAtSameMomentAs(lastCountDate);

    final bool isDayAvailable =
        isLastCountDayAvailable && isFirstCountDayAvailable;

    if (isDayAvailable) {
      updateCurrentDay(firstCountDate);
    }

    return isDayAvailable;
  }

  // calcula a quantidade total de sementes germinadas de cada lote referente ao Teste de Germinação
  // e atribui o valor a variável germinatedSeeds
  Future<void> totalGerminatedSeedGerminationTest(int idGerminationTest) async {
    LotRepository lotRepository = LotRepository();
    List<Lot> listLot = await lotRepository.getAllLots(idGerminationTest);

    for (var lot in listLot) {
      germinatedSeeds += lot.germinatedSeedPerLot;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      GerminationTestConst.kSPECIESCOLUMN: species,
      GerminationTestConst.kMATERIALCOLUMN: materialUsed,
      GerminationTestConst.kSUBSTRATECOLUMN: substratoUsed,
      GerminationTestConst.kTEMPERATURECOLUMN: temperature,
      GerminationTestConst.kCREATEATCOLUMN: createdAt.toString(),
      GerminationTestConst.kFIRSTCOUNTCOLUMN: firstCount,
      GerminationTestConst.kLASTCOUNTCOLUMN: lastCount,
      GerminationTestConst.kTOTALSEEDSCOLUMN: totalSeeds,
      GerminationTestConst.kGERMINATEDSEEDSCOLUMN: germinatedSeeds,
      GerminationTestConst.kCURRENTDAYCOLUMN: currentDay,
      GerminationTestConst.kSTATUSCOLUMN: status,
    };
  }

  GerminationTest.fromMap(Map map) {
    id = map[GerminationTestConst.kIDGERMINATIONTESTCOLUMN];
    species = map[GerminationTestConst.kSPECIESCOLUMN];
    materialUsed = map[GerminationTestConst.kMATERIALCOLUMN];
    substratoUsed = map[GerminationTestConst.kSUBSTRATECOLUMN];
    temperature = map[GerminationTestConst.kTEMPERATURECOLUMN];
    createdAt = map[GerminationTestConst.kCREATEATCOLUMN];
    firstCount = map[GerminationTestConst.kFIRSTCOUNTCOLUMN];
    lastCount = map[GerminationTestConst.kLASTCOUNTCOLUMN];
    totalSeeds = map[GerminationTestConst.kTOTALSEEDSCOLUMN];
    germinatedSeeds = map[GerminationTestConst.kGERMINATEDSEEDSCOLUMN];
    currentDay = map[GerminationTestConst.kCURRENTDAYCOLUMN];
    status = map[GerminationTestConst.kSTATUSCOLUMN];
  }

/* Future<void> totalGerminatedSeed(int idGerminationTest) async {
    // List<int> listTotalGerminationSeeds = [];
    LotRepository lotRepository = LotRepository();
    List<Lot> listLot = await lotRepository.getAllLots(idGerminationTest);

    for (var lot in listLot) {
      //print("ID DO LOT ENVIADO: ${lot.id}");
      totalGerminatedSeeds += lot.germinatedSeedPerLot;

      /* if (totalGerminationSeeds != 0) {
        //listTotalGerminationSeeds.add(totalGerminationSeeds);
        // print("listTotalGerminationSeeds = $listTotalGerminationSeeds");
      } */
    }
  } */

/*   static totalUngerminatedSeed() {
    int germinatedSeedsMock = 13;
    int totalSeedsMock = 20;
    int ungerminatedSeeds = totalSeedsMock - germinatedSeedsMock;
    //print("SEMENTES NÃO GERMINADAS: $ungerminatedSeeds");
    percentualGermination(totalSeedsMock, germinatedSeedsMock);
  }

  static percentualGermination(int totalSeeds, int germinatedSeeds) {
    double percGerminatedSeeds = (germinatedSeeds / totalSeeds) * 100;
    //print("PERCENTUAL DE SEMENTES GERMINADAS: $percGerminatedSeeds%");
  }

  static calculateMeanRepetition(/*Lot lot*/) {
    Map<int, List<int>> valuesMock = {
      1: [1, 0], // Dia 1: [R1, R2]
      2: [2, 1], // Dia 2: [R1, R2]
      3: [1, 3], // Dia 3: [R1, R2]
      4: [3, 2], // Dia 4: [R1, R2]
      //5: [1, 2], // Dia 5: [R1, R2]
    };

    int sumSeeds = 0;
    int numbeRepetitions =
        valuesMock.values.first.length; //lot.dailyCount.values.first!.length;
    valuesMock.forEach((key, values) {
      // Somar os valores da lista de cada repetição
      sumSeeds += values.reduce((sum, value) => sum + value);
    });

    //print("SOMA DAS SEMENTES GERMINADAS DAS REPETIÇÕES: $sumSeeds");
    //print("NÚMERO DE REPETIÇÕES: $numbeRepetitions");

    double meanRepetition = sumSeeds / numbeRepetitions;
    //print("MÉDIA DAS REPETIÇÕES: $meanRepetition");
  }

  importFile(String file) {}

  exportFile() {} */
}
