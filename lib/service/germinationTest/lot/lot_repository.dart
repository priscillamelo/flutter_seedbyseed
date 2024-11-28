import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_helper.dart';

class LotRepository {
  LotHelper helper = LotHelper();

  LotRepository();

  Future<int> addLot(Lot lot) async {
    int? idLot = await helper.insertLot(lot);

    return idLot ?? 0;
  }

  Future<List<Lot>> getAllLots(int idGerminationTest) async {
    List mapLots = await helper.getAllLots(idGerminationTest);
    List<Lot> allLots = [];

    for (Map l in mapLots) {
      allLots.add(Lot.fromMap(l));
    }

    return allLots;
  }
}
