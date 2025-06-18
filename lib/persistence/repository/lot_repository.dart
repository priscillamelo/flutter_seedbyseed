import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/persistence/helper/lot_helper.dart';

class LotRepository extends ChangeNotifier {
  LotHelper helper = LotHelper();

  LotRepository();

  Future<int> addLot(Lot lot) async {
    int? idLot = await helper.insertLot(lot);

    notifyListeners();
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

  Future<Lot> getLot(int idGerminationTest, int idLot) async {
    List listLot = await helper.getLot(idGerminationTest, idLot);

    // Converte o resultado para a classe Lot
    if (listLot.isNotEmpty) {
      return Lot.fromMap(listLot.first); // Usa o método fromMap para criar a instância
    } else {
      throw Exception('Nenhum lote encontrado para o ID do teste $idGerminationTest e lote $idLot.');
    }
  }

  Future<Map<int, List<int>?>>? getDailyCountLot(int idGerminationTest, int idLot) async {
    Lot? lot = await helper.getDailyCount(idGerminationTest, idLot);

    if (lot != null) {
      return lot.dailyCount;
    } else {
      throw Exception('DailyCount não encontrado!');
    }
  }

  Future<void> updateDailyCountLot(int idGerminationTest, Lot lot) async {
    await helper.updateDailyCount(idGerminationTest, lot);

    notifyListeners();
  }

  Future<void> updateLot(Lot lot) async {
    await helper.updateLot(lot);
    notifyListeners();
  }
}
