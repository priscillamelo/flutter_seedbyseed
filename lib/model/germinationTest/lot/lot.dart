import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_const.dart';

class Lot {
  late int id;
  late int idGerminationTest;
  late int numberLot;

  Lot({required this.idGerminationTest, required this.numberLot});

  Map<String, dynamic> toMap() {
    return {
      LotConst.kIDLOTCOLUMN: id,
      LotConst.kNUMBERLOTCOLUMN: numberLot,
      LotConst.kIDGERMINATIONTESTFOREIGNKEY: idGerminationTest,
    };
  }

  Lot.fromMap(Map map) {
    id = map[LotConst.kIDLOTCOLUMN];
    numberLot = map[LotConst.kNUMBERLOTCOLUMN];
    idGerminationTest = map[LotConst.kIDGERMINATIONTESTFOREIGNKEY];
  }
}
