import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_const.dart';

class Repetition {
  late int id;
  late int lotId;
  late int seedsTotal;
  late int germinatedSeeds;

  Repetition(
      {required this.lotId,
      required this.seedsTotal,
      required this.germinatedSeeds});

  Map<String, dynamic> toMap() {
    return {
      RepetitionConst.kIDREPETITIONCOLUMN: id,
      RepetitionConst.kSEEDSTOTALCOLUMN: seedsTotal,
      RepetitionConst.kGERMINATEDSEEDSCOLUMN: germinatedSeeds,
      RepetitionConst.kIDLOTFOREIGNKEYREPETITION: lotId,
    };
  }

  Repetition.fromMap(Map map) {
    id = map[RepetitionConst.kIDREPETITIONCOLUMN];
    seedsTotal = map[RepetitionConst.kSEEDSTOTALCOLUMN];
    germinatedSeeds = map[RepetitionConst.kGERMINATEDSEEDSCOLUMN];
    lotId = map[RepetitionConst.kIDLOTFOREIGNKEYREPETITION];
  }
}
