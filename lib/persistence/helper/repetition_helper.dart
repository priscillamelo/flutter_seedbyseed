import 'package:flutter_seedbyseed/infra/database/database_app.dart';
import 'package:flutter_seedbyseed/domain/model/repetition.dart';
import 'package:flutter_seedbyseed/persistence/constants/repetition_const.dart';
import 'package:sqflite/sqflite.dart';

class RepetitionHelper {
  final DatabaseApp _databaseApp = DatabaseApp.instanceDatabaseApp;
  final String tableName = RepetitionConst.kREPETITIONTABLE;

  Future<int> insertRepetition(Repetition repetition) async {
    final Database database = await _databaseApp.getDatabase;
    final Future<int> numberRowsAffected;

    numberRowsAffected = database.insert(tableName, repetition.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return numberRowsAffected;
  }

  Future<List> getAllRepetitions(int idLot) async {
    final Database database = await _databaseApp.getDatabase;
    final List listRepetition = (await database.query(tableName, where: '${RepetitionConst.kIDLOTFOREIGNKEYREPETITION} = ?', whereArgs: [idLot]));

    return listRepetition;
  }

  Future<void> updateRepetition(Repetition repetition) async {
    final Database database = await _databaseApp.getDatabase;
    await database.update(
      tableName,
      repetition.toMap(),
      where: '${RepetitionConst.kIDREPETITIONCOLUMN} = ?',
      whereArgs: [repetition.id],
    );
  }
}
