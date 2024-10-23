import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';

class GerminationTest {
  late int id;
  late String species;
  //late Responsavel _responsible;
  late int lot;
  late String materialUsed;
  late String substratoUsed;
  late String temperature;
  late int duration;
  late int firstCount;
  late int lastCount;
  late int
      repetition; // TALVEZ SEJA NECESSARIO QUE O TIPO SEJA UM MAP, PARA CADA REPETICAO (INT) TERA SUA QUANTIDADE DE SEMENTES GERMINADAS (INT)
  late int totalSeeds;

  GerminationTest(
      {required this.species,
      required this.lot,
      required this.materialUsed,
      required this.substratoUsed,
      required this.temperature,
      required this.duration,
      required this.firstCount,
      required this.lastCount,
      required this.repetition,
      required this.totalSeeds});

  GerminationTest.fromMap(Map map) {
    id = map[GerminationTestConst.kIDGERMINATIONTESTCOLUMN];
    species = map[GerminationTestConst.kSPECIESCOLUMN];
    lot = map[GerminationTestConst.kLOTCOLUMN];
    materialUsed = map[GerminationTestConst.kMATERIALCOLUMN];
    substratoUsed = map[GerminationTestConst.kSUBSTRATECOLUMN];
    temperature = map[GerminationTestConst.kTEMPERATURECOLUMN];
    duration = map[GerminationTestConst.kDURATIONCOLUMN];
    firstCount = map[GerminationTestConst.kFIRSTCOUNTCOLUMN];
    lastCount = map[GerminationTestConst.kLASTCOUNTCOLUMN];
    repetition = map[GerminationTestConst.kREPETITIONCOLUMN];
    totalSeeds = map[GerminationTestConst.kTOTALSEEDSCOLUMN];
  }

  Map<String, dynamic> toMap() {
    return {
      GerminationTestConst.kSPECIESCOLUMN: species,
      GerminationTestConst.kLOTCOLUMN: lot,
      GerminationTestConst.kMATERIALCOLUMN: materialUsed,
      GerminationTestConst.kSUBSTRATECOLUMN: substratoUsed,
      GerminationTestConst.kTEMPERATURECOLUMN: temperature,
      GerminationTestConst.kDURATIONCOLUMN: duration,
      GerminationTestConst.kFIRSTCOUNTCOLUMN: firstCount,
      GerminationTestConst.kLASTCOUNTCOLUMN: lastCount,
      GerminationTestConst.kREPETITIONCOLUMN: repetition,
      GerminationTestConst.kTOTALSEEDSCOLUMN: totalSeeds
    };
  }

  totalUngerminatedSeed() {}

  percentualGermination() {}

  calculateIVG() {}

  calculateMeanRepetition() {}

  importFile(String file) {}

  exportFile() {}
}
