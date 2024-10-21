import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_helper.dart';

class GerminationTestRepository {
  String get sqlTable => """
CREATE TABLE ${GerminationTestConst.kGERMINATIONTESTTABLE} (
  ${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${GerminationTestConst.kSPECIESCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kLOTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kMATERIALCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kSUBSTRATECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kTEMPERATURECOLUMN} TEXT NUMERIC NOT NULL,
  ${GerminationTestConst.kDURATIONCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kFIRSTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kLASTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kREPETITIONCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kTOTALSEEDSCOLUMN} INTEGER NOT NULL
);
""";

  GerminationTestRepository() {
    _initRepository();
  }
  final GerminationTestHelper _helper = GerminationTestHelper();

  _initRepository() async {
    await getAllGerminationTest();
  }

  Future<List<GerminationTest>> getAllGerminationTest() async {
    List mapGerminationTest = await _helper.getAllGerminationTest();
    List<GerminationTest> allGerminationTest = [];

    for (Map g in mapGerminationTest) {
      allGerminationTest.add(GerminationTest.fromMap(g));
    }

    return allGerminationTest;
  }

  Future<int> addGerminationTest(GerminationTest germinationTest) async {
    int numberRowsAffected;
    numberRowsAffected = await _helper.addGerminationTest(germinationTest);

    return numberRowsAffected;
  }

  Future<GerminationTest?> getGerminationTest(int id) async {
    final GerminationTest? germinationTest;
    germinationTest = await _helper.getGerminationTest(id);

    return germinationTest;
  }

  Future<int> updateGerminationTest(GerminationTest germinationTest) async {
    int numberRowsAffected;
    numberRowsAffected = await _helper.updateGerminationTest(germinationTest);

    return numberRowsAffected;
  }

  Future<int> deleteGerminationTest(int id) async {
    int numberRowsAffected;
    numberRowsAffected = await _helper.deleteGerminationTest(id);

    return numberRowsAffected;
  }
}
