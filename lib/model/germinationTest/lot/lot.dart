import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_const.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_repository.dart';

class Lot {
  late int id;
  late int idGerminationTest;
  late int numberLot;
  late int germinatedSeedPerLot;

  Lot(
      {required this.idGerminationTest,
      required this.numberLot,
      required this.germinatedSeedPerLot});

  Map<String, dynamic> toMap() {
    return {
      LotConst.kNUMBERLOTCOLUMN: numberLot,
      LotConst.kGERMINATEDSEEDPERLOT: germinatedSeedPerLot,
      LotConst.kIDGERMINATIONTESTFOREIGNKEY: idGerminationTest,
    };
  }

  Lot.fromMap(Map map) {
    id = map[LotConst.kIDLOTCOLUMN];
    numberLot = map[LotConst.kNUMBERLOTCOLUMN];
    germinatedSeedPerLot = map[LotConst.kGERMINATEDSEEDPERLOT];
    idGerminationTest = map[LotConst.kIDGERMINATIONTESTFOREIGNKEY];
  }

  static Future<int> totalGerminatedSeedPerLot(int idLot) async {
    //print("ID DO LOTE RECEBIDO: $idLot");
    int totalGerminationSeeds = 0;
    RepetitionRepository repetitionRepository = RepetitionRepository();
    List<Repetition> listRepetition =
        await repetitionRepository.getAllRepetition(idLot);
    print("1 totalGerminationSeeds = $totalGerminationSeeds");

    for (var repetition in listRepetition) {
      //print("ID DA REPETIÇÃO: ${repetition.id}");
      print("SEMENTES GERMINADAS DA REPETIÇÃO: ${repetition.germinatedSeeds}");
      if (repetition.germinatedSeeds > 0) {
        totalGerminationSeeds += repetition.germinatedSeeds;
        print("2 totalGerminationSeeds = $totalGerminationSeeds");
        //print("TOTAL DE SEMENTES GERMINADAS: $totalGerminationSeeds");
      }
    }
    return totalGerminationSeeds;
  }
}
