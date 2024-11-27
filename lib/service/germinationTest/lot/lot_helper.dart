import 'package:flutter_seedbyseed/database/database_app.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_const.dart';
import 'package:sqflite/sqflite.dart';

class LotHelper {
  final DatabaseApp _databaseApp = DatabaseApp.instanceDatabaseApp;
  final String tableName = LotConst.kLOTTABLE;

  Future<int> insertLot(Lot lot) async {
    final Database database = await _databaseApp.getDatabase;

    int idLot = await database.insert(tableName, lot.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return idLot;
  }

  Future<List<Lot>> getAllLots(int idGerminationTest) async {
    final Database database = await _databaseApp.getDatabase;
    final List<Map<String, dynamic>> listMapLots = (await database.query(
        tableName,
        where: '${LotConst.kIDGERMINATIONTESTFOREIGNKEY} = ?',
        whereArgs: [idGerminationTest]));

    return List.generate(listMapLots.length, (index) {
      return Lot.fromMap(listMapLots[index]);
    });
  }

  /* Future<Lot> getLot(int idGerminationTest, int numberLot) async {
    final Database database = await _databaseApp.getDatabase;
    final List<Map<String, dynamic>> listMapLots = (await database.query(
        tableName,
        where: '${LotConst.kIDGERMINATIONTESTFOREIGNKEY} = ?',
        whereArgs: [idGerminationTest]));

    return List.generate(listMapLots.length, (index) {
      return Lot.fromMap(listMapLots[index]);
    });
  } */
}
