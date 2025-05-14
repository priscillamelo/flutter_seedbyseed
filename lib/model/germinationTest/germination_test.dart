import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';

class GerminationTest {
  static const inProgress = 'in_progress';
  static const finished = 'finished';
  static const canceled = 'canceled';

  late int id;
  late String species;
  //late Responsavel _responsible;
  late String materialUsed;
  late String substratoUsed;
  late String temperature;
  late int firstCount;
  late int lastCount;
  late int totalSeeds;
  late int germinatedSeeds;
  int currentDay = 1;
  String status = GerminationTest.inProgress;

  GerminationTest({
    required this.species,
    required this.materialUsed,
    required this.substratoUsed,
    required this.temperature,
    required this.firstCount,
    required this.lastCount,
    required this.totalSeeds,
    required this.germinatedSeeds,
  });

  Map<String, dynamic> toMap() {
    return {
      GerminationTestConst.kSPECIESCOLUMN: species,
      GerminationTestConst.kMATERIALCOLUMN: materialUsed,
      GerminationTestConst.kSUBSTRATECOLUMN: substratoUsed,
      GerminationTestConst.kTEMPERATURECOLUMN: temperature,
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
