import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportarExcel(List<Lot> lotes) async {
  /* // Lista de cores para alternar entre os lotes
  final coresLotes = [
    ExcelColor.pink50, // rosa claro
    ExcelColor.yellow50, // amarelo claro,
    ExcelColor.blue50, // azul claro
    ExcelColor.green50, // verde claro
    ExcelColor.purple50, // roxo claro
  ];

  var excel = Excel.createExcel();
  final Sheet sheet = excel['Germinação'];

  // Identifica número de repetições e dias
  final dias = lotes.first.dailyCount.keys.toList()..sort();
  final qtdRepeticoes = lotes.first.dailyCount[dias.first]?.length ?? 0;

  // Adiciona dados com destaque
  CellStyle estiloCabecalho = CellStyle(
    bold: true,
    backgroundColorHex: ExcelColor.yellow50
  );

  // Monta cabeçalho
  final cabecalho = ["Amostra", "Rep."] + dias.map((e) => e.toString()).toList();
  sheet.appendRow(cabecalho.map((v) => TextCellValue(v)).toList());

  for (var cell in sheet.row(0)) {
    cell?.cellStyle = estiloCabecalho;
  }

  int linhaAtual = 1; // Começa após o cabeçalho
  // Monta linhas para cada lote
  for (int i = 0; i < lotes.length; i++) {
    final lote = lotes[i];
    final corLote = coresLotes[i]; // alterna cor entre os lotes

    for (int repIndex = 0; repIndex < qtdRepeticoes; repIndex++) {
      final List<CellValue> linha = [];

      sheet.appendRow([
        TextCellValue(repIndex == 0 ? "LOTE ${i + 1}" : ""), // só mostra o nome do lote 1x
        TextCellValue("R${repIndex + 1}"),
      ]);
    }
      // Mescla as células da coluna A para o lote
  sheet.merge(
    CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: linhaAtual),                  // Ex: A2
    CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: linhaAtual + qtdRepeticoes - 1),   // Ex: A5
  );

  linhaAtual += qtdRepeticoes; // move para o próximo grupo de linhas
    

      // Colunas dos dias
      for (var dia in dias) {
        final listaReps = lote.dailyCount[dia] ?? [];
        final valor = (repIndex < listaReps.length) ? listaReps[repIndex] : 0;
        linha.add(IntCellValue(valor));
      }

      // Adiciona a linha
      final rowIndex = sheet.maxRows;
      sheet.appendRow(linha);

      // Aplica estilo para cada célula da linha recém-adicionada
      for (var cell in sheet.row(rowIndex)) {
        cell?.cellStyle = CellStyle(backgroundColorHex: corLote);
      }

      sheet.appendRow(linha);
    }
  }

  /*// Preenche os dados
  for (int i = 0; i < lotes.length; i++) {
    final lote = lotes[i];
    lote.dailyCount.forEach((dia, repeticoes) {
      final linha = [
        TextCellValue("Lote ${i + 1}"),
        IntCellValue(dia),
        for (var r in repeticoes ?? []) IntCellValue(r)
      ];
      sheet.appendRow(linha);
    });
  }*/
  /*
  sheet.appendRow([TextCellValue("Nome") , TextCellValue("Idade"), TextCellValue("Curso")]);
  for (var cell in sheet.row(0)) {
    cell?.cellStyle = estiloCabecalho;
  }

  sheet.appendRow([TextCellValue("Priscilla") , const IntCellValue(27), TextCellValue("ADS")]);
  sheet.appendRow([TextCellValue("Fulano") , const IntCellValue(30), TextCellValue("SI")]);*/

  // Salva o arquivo
  final directory = Directory('/storage/emulated/0/Download');
  final path = "${directory.path}/relatorio_teste_de_germinacao.xlsx";
  final fileBytes = excel.save();

  final File file = File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
 */
  final excel = Excel.createExcel();
  final Sheet sheet = excel['Germinação'];

  // Estilo do cabeçalho
  final estiloCabecalho = CellStyle(
    bold: true,
    backgroundColorHex: ExcelColor.grey100,
    fontFamily: getFontFamily(FontFamily.Calibri),
  );

  // Lista de cores para alternar entre os lotes
  final coresLotes = [
    ExcelColor.pink50, // rosa claro
    ExcelColor.yellow50, // amarelo claro,
    ExcelColor.blue50, // azul claro
    ExcelColor.green50, // verde claro
    ExcelColor.purple50, // roxo claro
  ];

  // Detecta dinamicamente todos os dias (chaves do dailyCount)
  final dias = lotes.first.dailyCount.keys.toList()..sort();
  final totalReps = lotes.first.dailyCount.values.first?.length ?? 0;

  // Cabeçalho
  final cabecalho = ['Amostra', 'Rep.'] + dias.map((d) => d.toString()).toList();
  sheet.appendRow(cabecalho.map((e) => TextCellValue(e)).toList());
  for (var cell in sheet.row(0)) {
    cell?.cellStyle = estiloCabecalho;
  }

  int linhaAtual = 1; // Linha inicial (após o cabeçalho)

  for (int i = 0; i < lotes.length; i++) {
    //final lote = lotes[i];
    final corFundo = CellStyle(
      backgroundColorHex: coresLotes[i % coresLotes.length],
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    for (int rep = 0; rep < totalReps; rep++) {
      final linha = <Data?>[];

      //linha.add(TextCellValue(rep == 0 ? 'LOTE ${i + 1}' : ''));
      //linha.add(TextCellValue('R${rep + 1}'));

      /* for (int dia in dias) {
        final valor = lote.dailyCount[dia]?[rep] ?? 0;
        //linha.add(IntCellValue(valor));
      } */

      //sheet.appendRow(linha);

      // Aplica cor de fundo às células da linha
      for (int col = 0; col < linha.length; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: linhaAtual)).cellStyle = corFundo;
      }

      linhaAtual++;
    }

    // Mescla o nome do lote na coluna "Amostra"
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: linhaAtual - totalReps),
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: linhaAtual - 1),
    );
  }

  // Permissões e salvamento
  if (await Permission.storage.request().isGranted) {
    final directory = await getExternalStorageDirectory();
    final path = "${directory!.path}/daily_count_export.xlsx";
    final bytes = excel.encode();
    final file = File(path);
    await file.writeAsBytes(Uint8List.fromList(bytes!));
    debugPrint("✅ Arquivo Excel salvo em: $path");
  } else {
    debugPrint("Permissão de armazenamento negada.");
  }
}
