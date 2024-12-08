import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';

class GerminationTest {
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

  GerminationTest(
      {required this.species,
      required this.materialUsed,
      required this.substratoUsed,
      required this.temperature,
      required this.firstCount,
      required this.lastCount,
      required this.totalSeeds,
      required this.germinatedSeeds});

  Map<String, dynamic> toMap() {
    return {
      GerminationTestConst.kSPECIESCOLUMN: species,
      GerminationTestConst.kMATERIALCOLUMN: materialUsed,
      GerminationTestConst.kSUBSTRATECOLUMN: substratoUsed,
      GerminationTestConst.kTEMPERATURECOLUMN: temperature,
      GerminationTestConst.kFIRSTCOUNTCOLUMN: firstCount,
      GerminationTestConst.kLASTCOUNTCOLUMN: lastCount,
      GerminationTestConst.kTOTALSEEDSCOLUMN: totalSeeds,
      GerminationTestConst.kGERMINATEDSEEDSCOLUMN: germinatedSeeds
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

  totalUngerminatedSeed() {}

  percentualGermination() {}

  calculateIVG() {}

  calculateMeanRepetition() {}

  importFile(String file) {}

  exportFile() {}
}
