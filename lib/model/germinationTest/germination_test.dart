import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';

class GerminationTest {
  late int id;
  late String species;
  //late Responsavel _responsible;
  late String materialUsed;
  late String substratoUsed;
  late String temperature;
  late int firstCount;
  late int lastCount;
  late int totalSeeds;
  late int germinatedSeeds;
  int currentDay = 1;
  String lastRecordedDate = '';
  //TODO: ALTERAR O NOME DA VARIAVEL PARA STATUS
  int finished = 0;
  double ivg = 0.0;

  GerminationTest({
    required this.species,
    required this.materialUsed,
    required this.substratoUsed,
    required this.temperature,
    required this.firstCount,
    required this.lastCount,
    required this.totalSeeds,
    required this.germinatedSeeds,
  });

  Map<String, dynamic> toMap() {
    return {
      GerminationTestConst.kSPECIESCOLUMN: species,
      GerminationTestConst.kMATERIALCOLUMN: materialUsed,
      GerminationTestConst.kSUBSTRATECOLUMN: substratoUsed,
      GerminationTestConst.kTEMPERATURECOLUMN: temperature,
      GerminationTestConst.kFIRSTCOUNTCOLUMN: firstCount,
      GerminationTestConst.kLASTCOUNTCOLUMN: lastCount,
      GerminationTestConst.kTOTALSEEDSCOLUMN: totalSeeds,
      GerminationTestConst.kGERMINATEDSEEDSCOLUMN: germinatedSeeds,
      GerminationTestConst.kCURRENTDAYCOLUMN: currentDay,
      GerminationTestConst.kLASTRECORDEDDATECOLUMN: lastRecordedDate,
      GerminationTestConst.kFINISHEDCOLUMN: finished,
    };
  }

  GerminationTest.fromMap(Map map) {
    id = map[GerminationTestConst.kIDGERMINATIONTESTCOLUMN];
    species = map[GerminationTestConst.kSPECIESCOLUMN];
    materialUsed = map[GerminationTestConst.kMATERIALCOLUMN];
    substratoUsed = map[GerminationTestConst.kSUBSTRATECOLUMN];
    temperature = map[GerminationTestConst.kTEMPERATURECOLUMN];
    firstCount = map[GerminationTestConst.kFIRSTCOUNTCOLUMN];
    lastCount = map[GerminationTestConst.kLASTCOUNTCOLUMN];
    totalSeeds = map[GerminationTestConst.kTOTALSEEDSCOLUMN];
    germinatedSeeds = map[GerminationTestConst.kGERMINATEDSEEDSCOLUMN];
    currentDay = map[GerminationTestConst.kCURRENTDAYCOLUMN];
    lastRecordedDate = map[GerminationTestConst.kLASTRECORDEDDATECOLUMN];
    finished = map[GerminationTestConst.kFINISHEDCOLUMN];
  }

  /* Future<void> totalGerminatedSeed(int idGerminationTest) async {
    // List<int> listTotalGerminationSeeds = [];
    LotRepository lotRepository = LotRepository();
    List<Lot> listLot = await lotRepository.getAllLots(idGerminationTest);

    for (var lot in listLot) {
      //print("ID DO LOT ENVIADO: ${lot.id}");
      totalGerminatedSeeds += lot.germinatedSeedPerLot;

      /* if (totalGerminationSeeds != 0) {
        //listTotalGerminationSeeds.add(totalGerminationSeeds);
        // print("listTotalGerminationSeeds = $listTotalGerminationSeeds");
      } */
    }
  } */

  // FIXME: RETIRAR O STATIC
  static calculateIVG(Lot? lot) {
    // Criar o resultado final
    Map<String, List<double>> resultDivisions = {};

    Map<int, List<int>> valuesMock = {
      1: [1, 0], // Dia 1: [R1, R2]
      2: [1, 2], // Dia 2: [R1, R2]
      3: [2, 1], // Dia 3: [R1, R2]
      4: [3, 3], // Dia 4: [R1, R2]
      5: [1, 2], // Dia 5: [R1, R2]
    };

    // Número de repetições (colunas em cada lista)
    int repetitions =
        valuesMock.values.first.length; //lot.dailyCount.values.first!.length;
    print("Número de repetições (colunas): $repetitions");

    // Iterar sobre o número de repetições
    for (int i = 0; i < repetitions; i++) {
      String repetitionKey = "R${i + 1}"; // Nome da repetição (R1, R2, etc.)
      List<double> repetitionDivisionPerDay = [];

      valuesMock.forEach((day, values) {
        // Dividir o valor pela chave (dia) e adicionar ao resultado
        repetitionDivisionPerDay.add(
          double.parse(
            (values[i] / day).toStringAsFixed(2),
          ),
        );
        print(
            "Divisão do valor da repetição pelo o dia: $repetitionDivisionPerDay");
      });
      /* lot!.dailyCount.forEach((day, values) {
        // Dividir o valor pela chave (dia) e adicionar ao resultado
        repetitionDivisionPerDay.add(values![i] / day);
        print(
            "Divisão do valor da repetição pelo o dia: $repetitionDivisionPerDay");
      }); */

      resultDivisions[repetitionKey] =
          repetitionDivisionPerDay; // Adicionar ao mapa final
    }

    print(
        "RESULTADO DAS DIVISÕES: $resultDivisions"); // Exibe o mapa resultante

    // Calcular o IVG para cada repetição
    Map<String, double> calculateIVG = {};

    resultDivisions.forEach((key, values) {
      // Somar os valores da lista de cada repetição
      calculateIVG[key] = values.reduce((sum, value) => sum + value);
    });

    // Imprimir os resultados
    print("Cálculos Intermediários: $resultDivisions");
    print("IVG Final: $calculateIVG");
  }

  static totalUngerminatedSeed() {
    int germinatedSeedsMock = 13;
    int totalSeedsMock = 20;
    int ungerminatedSeeds = totalSeedsMock - germinatedSeedsMock;
    print("SEMENTES NÃO GERMINADAS: $ungerminatedSeeds");
    percentualGermination(totalSeedsMock, germinatedSeedsMock);
  }

  static percentualGermination(int totalSeeds, int germinatedSeeds) {
    double percGerminatedSeeds = (germinatedSeeds / totalSeeds) * 100;
    print("PERCENTUAL DE SEMENTES GERMINADAS: $percGerminatedSeeds%");
  }

  static calculateMeanRepetition(/*Lot lot*/) {
    Map<int, List<int>> valuesMock = {
      1: [1, 0], // Dia 1: [R1, R2]
      2: [2, 1], // Dia 2: [R1, R2]
      3: [1, 3], // Dia 3: [R1, R2]
      4: [3, 2], // Dia 4: [R1, R2]
      //5: [1, 2], // Dia 5: [R1, R2]
    };

    int sumSeeds = 0;
    int numbeRepetitions =
        valuesMock.values.first.length; //lot.dailyCount.values.first!.length;
    valuesMock.forEach((key, values) {
      // Somar os valores da lista de cada repetição
      sumSeeds += values.reduce((sum, value) => sum + value);
    });

    print("SOMA DAS SEMENTES GERMINADAS DAS REPETIÇÕES: $sumSeeds");
    print("NÚMERO DE REPETIÇÕES: $numbeRepetitions");

    double meanRepetition = sumSeeds / numbeRepetitions;
    print("MÉDIA DAS REPETIÇÕES: $meanRepetition");
  }

  importFile(String file) {}

  exportFile() {}
}
