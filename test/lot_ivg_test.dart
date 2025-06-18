import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Lot - Cálculo de IVG com base em dados reais', () {
    test('Cálculo do IVG e média do primeiro lote', () {
      final lot = Lot(
        idGerminationTest: 1,
        numberLot: 1,
        dailyCount: {
          1: [0, 0, 0, 0],
          2: [12, 3, 8, 10],
          3: [25, 29, 38, 24],
          4: [2, 5, 2, 4],
          5: [0, 5, 0, 2],
          6: [2, 2, 0, 0],
          7: [0, 0, 0, 0],
          8: [0, 0, 0, 0],
          9: [0, 0, 0, 0],
          10: [0, 0, 0, 0],
          11: [0, 0, 0, 0],
          12: [0, 0, 0, 0],
          13: [0, 0, 0, 0],
          14: [0, 0, 0, 0],
          15: [0, 0, 0, 0],
        },
      );

      // Chamada da função que será testada
      lot.calculateIVGPerLot();

      // Verificações dos valores esperados por repetição
      expect(lot.ivgPerLot["R1"], 15.16);
      expect(lot.ivgPerLot["R2"], 13.75);
      expect(lot.ivgPerLot["R3"], 17.17);
      expect(lot.ivgPerLot["R4"], 14.4);

      // Verificação do IVG médio do lote
      expect(lot.averageIVG, 15.12);
    });
  });
}
