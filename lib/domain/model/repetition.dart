import 'package:flutter_seedbyseed/persistence/constants/repetition_const.dart';

class Repetition {
  int? id;
  late int lotId;
  late int seedsTotal;
  int germinatedSeeds;

  Repetition({required this.lotId, required this.seedsTotal, this.germinatedSeeds = 0});

  Map<String, dynamic> toMap() {
    return {
      RepetitionConst.kSEEDSTOTALCOLUMN: seedsTotal,
      RepetitionConst.kGERMINATEDSEEDSCOLUMN: germinatedSeeds,
      RepetitionConst.kIDLOTFOREIGNKEYREPETITION: lotId,
    };
  }

  Repetition.fromMap(Map map)
      : id = map[RepetitionConst.kIDREPETITIONCOLUMN],
        seedsTotal = map[RepetitionConst.kSEEDSTOTALCOLUMN],
        germinatedSeeds = map[RepetitionConst.kGERMINATEDSEEDSCOLUMN],
        lotId = map[RepetitionConst.kIDLOTFOREIGNKEYREPETITION];
}
