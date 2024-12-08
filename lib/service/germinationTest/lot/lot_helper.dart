import 'package:flutter/foundation.dart';
import 'package:flutter_seedbyseed/database/database_app.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_const.dart';
import 'package:sqflite/sqflite.dart';

class LotHelper {
  final DatabaseApp _databaseApp = DatabaseApp.instanceDatabaseApp;
  final String tableName = LotConst.kLOTTABLE;

  Future<int?> insertLot(Lot lot) async {
    final Database database = await _databaseApp.getDatabase;

    try {
      int idLot = await database.insert(
        tableName,
        lot.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return idLot;
    } catch (e) {
      debugPrint("Erro ao adicionar o lot no banco");
    }
    return null;
  }

  Future<List> getAllLots(int idGerminationTest) async {
    final Database database = await _databaseApp.getDatabase;
    final List listMapLots = await database.query(tableName,
        where: '${LotConst.kIDGERMINATIONTESTFOREIGNKEY} = ?',
        whereArgs: [idGerminationTest]);

    return listMapLots;
  }

  Future<List> getLot(int idGerminationTest, int idLot) async {
    final Database database = await _databaseApp.getDatabase;
    final List listLot = await database.query(
      tableName,
      limit: 1,
      where:
          '${LotConst.kIDGERMINATIONTESTFOREIGNKEY} = ? AND ${LotConst.kIDLOTCOLUMN} = ?',
      whereArgs: [idGerminationTest, idLot],
    );

    return listLot;
  }

  Future<void> updateLot(Lot lot) async {
    final Database database = await _databaseApp.getDatabase;
    await database.update(
      tableName,
      lot.toMap(),
      where: '${LotConst.kIDLOTCOLUMN} = ?',
      whereArgs: [lot.id],
    );
  }
}
