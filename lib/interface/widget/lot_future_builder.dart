import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
import 'package:flutter_seedbyseed/interface/widget/repetition_future_builder.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';

class LotFutureBuilder extends StatefulWidget {
  final GerminationTest germinationTest;
  final bool isNewDay;

  const LotFutureBuilder({
    super.key,
    required this.germinationTest,
    required this.isNewDay,
  });

  @override
  State<LotFutureBuilder> createState() => _LotFutureBuilderState();
}

class _LotFutureBuilderState extends State<LotFutureBuilder>
    with TickerProviderStateMixin {
  late LotRepository lotRepository;
  late Future<List<Lot>> listLot;
  late final PageController _pageViewController;
  int _currentPageIndex = 0;
  final Map<int, Future<void> Function()> _pageSaveFunctions = {};

  @override
  void initState() {
    super.initState();
    lotRepository = LotRepository();
    listLot = lotRepository.getAllLots(widget.germinationTest.id!);
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  // NOVO HELPER: Centraliza a lógica de salvamento da página atual.
  Future<void> _saveCurrentPage() async {
    // Pega a função de salvar da página que estamos SAINDO.
    final saveFunction = _pageSaveFunctions[_currentPageIndex];
    if (saveFunction != null) {
      // Espera o salvamento ser concluído.
      await saveFunction();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<List<Lot>>(
      future: listLot,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Erro ao carregar os dados.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        final lots = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Chip(
                  avatar: const Icon(Icons.calendar_today, size: 20),
                  label: Text(
                    "Dia ${widget.germinationTest.currentDay}",
                    style: theme.textTheme.titleMedium,
                  ),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentPageIndex > 0
                        ? () async {
                            await _saveCurrentPage();

                            _pageViewController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    iconSize: 32,
                  ),
                  Text(
                    "Lote ${lots[_currentPageIndex].numberLot} de ${lots.length}",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _currentPageIndex < lots.length - 1
                        ? () async {
                            await _saveCurrentPage();
                            _pageViewController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    iconSize: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PageView.builder(
                  itemCount: lots.length,
                  controller: _pageViewController,
                  onPageChanged: (index) async {
                    await _saveCurrentPage();
                    setState(() => _currentPageIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final lot = lots[index];
                    final isLastPage = index == lots.length - 1;
                    return RepetitionFutureBuilder(
                      lot: lot,
                      germinationTest: widget.germinationTest,
                      lastPage: isLastPage,
                      isNewDay: widget.isNewDay,
                      onSaveReady: (saveFunction) {
                        _pageSaveFunctions[index] = saveFunction;
                      },
                      // FORNECENDO A IMPLEMENTAÇÃO DOS NOVOS CALLBACKS
                      onSaveAndGoNext: () {
                        _pageViewController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      onSaveAndFinish: () {
                        // Garante que o contexto ainda é válido antes de dar pop
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
