import 'package:flutter_seedbyseed/model/germinationTest/enum/material_enum.dart';
import 'package:flutter_seedbyseed/model/germinationTest/enum/substrate_enum.dart';

class GerminationTest {
  final String especie;
  //final Responsavel _responsavel;
  final List<int> lote;
  final MaterialEnum materialUtilizado;
  final SubstrateEnum substratoUtilizado;
  final double temperatura;
  final DateTime duracao;
  final int primeiraContage;
  final int contagemFinal;
  final List<int>
      repeticao; // TALVEZ SEJA NECESSARIO QUE O TIPO SEJA UM MAP, PARA CADA REPETICAO (INT) TERA SUA QUANTIDADE DE SEMENTES GERMINADAS (INT)
  final int totalSementes;

  GerminationTest(this.substratoUtilizado,
      {required this.especie,
      required this.lote,
      required this.materialUtilizado,
      required this.temperatura,
      required this.duracao,
      required this.primeiraContage,
      required this.contagemFinal,
      required this.repeticao,
      required this.totalSementes});

  totalUngerminatedSeed() {}

  percentualGermination() {}

  calculateIVG() {}

  calculateMeanRepetition() {}

  importFile(String file) {}

  exportFile() {}
}
