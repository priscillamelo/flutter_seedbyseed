import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/infra/config/export_excel.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:provider/provider.dart';

class DetailsGerminationTest extends StatefulWidget {
  const DetailsGerminationTest({super.key});

  @override
  State<DetailsGerminationTest> createState() => _DetailsGerminationTestState();
}

class _DetailsGerminationTestState extends State<DetailsGerminationTest> {
  late Future<List<Lot>> _futureLots;
  late GerminationTest _test;
  late LotRepository _lotRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lotRepository = Provider.of<LotRepository>(context);
    _test = ModalRoute.of(context)!.settings.arguments as GerminationTest;
    _futureLots = _lotRepository.getAllLots(_test.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Teste"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.center,
            child: Text(
              "Espécie: ${_test.species}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Lot>>(
        future: _futureLots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return _buildError(error: snapshot.error);
          }

          final lots = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lots.length,
            itemBuilder: (context, index) {
              final lot = lots[index];
              return _buildLotCard(context, lot);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "exportarTesteGerminacao",
        tooltip: "Exportar dados do Teste de Germinação",
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          List<Lot> listLot = await _futureLots;
          if (context.mounted) await lidarComExportacao(context, listLot);
        },
        child: Icon(
          Amicons.remix_file_excel2_fill,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  // Card do Lote com as novas barras de progresso
  Widget _buildLotCard(BuildContext context, Lot lot) {
    // Exemplo fixo — substituir por valores reais depois
    final double averageGermination =
        (lot.totalSeeds / lot.germinatedSeedPerLot) * 100;
    final double averageIVG = lot.averageIVG;

    final germinationByRep = [
      {"label": "R1: 87%", "value": 0.87},
      {"label": "R2: 83%", "value": 0.83},
      {"label": "R3: 76%", "value": 0.76},
      {"label": "R4: 76%", "value": 0.76},
    ];

    final ivgChips = ["R1: 1.2", "R2: 1.5", "R3: 1.6", "R4: 1.6"];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do Lote e progresso geral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lote ${lot.numberLot}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircularProgressIndicator(
                  value: averageGermination,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // IVG Médio
            _infoRow(
              icon: Amicons.lucide_gauge,
              label: "Média do IVG",
              value: averageIVG.toString(),
            ),
            const SizedBox(height: 24),

            // Germinação por Repetição com barra de progresso
            _progressGroup(
              icon: Amicons.remix_percent_fill,
              label: "Germinação por Repetição",
              items: germinationByRep,
            ),
            const SizedBox(height: 24),

            // IVG por Repetição (mantém chips)
            _chipGroup(
              icon: Amicons.remix_timer_fill,
              label: "IVG por Repetição",
              values: ivgChips,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text("$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }

  Widget _progressGroup({
    required IconData icon,
    required String label,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          padding: const EdgeInsets.only(right: 24),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 5.5,
          children: items
              .map((item) => _buildProgressChip(
                    label: item["label"],
                    progress: item["value"],
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _chipGroup({
    required IconData icon,
    required String label,
    required List<String> values,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: values
              .map((e) => Chip(
                    label: Text(e),
                    backgroundColor: Colors.grey.shade100,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProgressChip({
    required String label,
    required double progress,
    Color color = Colors.green,
  }) {
    return Container(
      width: 90,
      height: 32,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError({Object? error}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Erro ao carregar dados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? "Erro desconhecido",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
