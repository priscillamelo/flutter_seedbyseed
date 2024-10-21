import 'package:flutter_seedbyseed/model/germinationTest/enum/material_enum.dart';
import 'package:flutter_seedbyseed/model/germinationTest/enum/substrate_enum.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';

class GerminationTest {
  int id = 0;
  late String species;
  //late Responsavel _responsible;
  late List<int> lot;
  late MaterialEnum materialUsed;
  late SubstrateEnum substratoUsed;
  late double temperature;
  late DateTime duration;
  late int firstCount;
  late int lastCount;
  late List<int>
      repetition; // TALVEZ SEJA NECESSARIO QUE O TIPO SEJA UM MAP, PARA CADA REPETICAO (INT) TERA SUA QUANTIDADE DE SEMENTES GERMINADAS (INT)
  late int totalSeeds;

  GerminationTest(this.substratoUsed,
      {required this.species,
      required this.lot,
      required this.materialUsed,
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
      GerminationTestConst.kIDGERMINATIONTESTCOLUMN: id,
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
