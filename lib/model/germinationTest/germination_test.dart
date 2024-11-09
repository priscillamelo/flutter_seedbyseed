import 'dart:convert';

import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';

class GerminationTest {
  late int id;
  late String species;
  //late Responsavel _responsible;
  late Map<int, int> lot;
  late String materialUsed;
  late String substratoUsed;
  late String temperature;
  late int duration;
  late int firstCount;
  late int lastCount;
  late Map<int, int> repetition;
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
    lot = Map<int, int>.from(jsonDecode(map[GerminationTestConst.kLOTCOLUMN]));
    materialUsed = map[GerminationTestConst.kMATERIALCOLUMN];
    substratoUsed = map[GerminationTestConst.kSUBSTRATECOLUMN];
    temperature = map[GerminationTestConst.kTEMPERATURECOLUMN];
    duration = map[GerminationTestConst.kDURATIONCOLUMN];
    firstCount = map[GerminationTestConst.kFIRSTCOUNTCOLUMN];
    lastCount = map[GerminationTestConst.kLASTCOUNTCOLUMN];
    repetition = Map<int, int>.from(
        jsonDecode(map[GerminationTestConst.kREPETITIONCOLUMN]));
    totalSeeds = map[GerminationTestConst.kTOTALSEEDSCOLUMN];
  }

  Map<String, dynamic> toMap() {
    return {
      GerminationTestConst.kSPECIESCOLUMN: species,
      GerminationTestConst.kLOTCOLUMN: jsonEncode(lot),
      GerminationTestConst.kMATERIALCOLUMN: materialUsed,
      GerminationTestConst.kSUBSTRATECOLUMN: substratoUsed,
      GerminationTestConst.kTEMPERATURECOLUMN: temperature,
      GerminationTestConst.kDURATIONCOLUMN: duration,
      GerminationTestConst.kFIRSTCOUNTCOLUMN: firstCount,
      GerminationTestConst.kLASTCOUNTCOLUMN: lastCount,
      GerminationTestConst.kREPETITIONCOLUMN: jsonEncode(repetition),
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
