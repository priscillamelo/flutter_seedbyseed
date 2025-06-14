import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/repetition_future_builder.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart';
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
  bool lastPage = false;

  @override
  void initState() {
    super.initState();
    lotRepository = LotRepository();
    listLot = lotRepository.getAllLots(widget.germinationTest.id);
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lot>>(
      future: listLot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final lots = snapshot.data!;

          if (lots.isEmpty) {
            return const Center(child: Text('Nenhum lote cadastrado'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "Dia ${widget.germinationTest.currentDay}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentPageIndex > 0
                        ? IconButton(
                            onPressed: () {
                              _pageViewController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            iconSize: 32,
                          )
                        : const SizedBox(width: 48),
                    Text(
                      "Lote ${lots[_currentPageIndex].numberLot}",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _currentPageIndex < lots.length - 1
                        ? IconButton(
                            onPressed: () {
                              _pageViewController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            iconSize: 32,
                          )
                        : const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: lots.length,
                  controller: _pageViewController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    lastPage = _currentPageIndex == lots.length - 1;
                    return Center(
                      child: RepetitionFutureBuilder(
                        lot: lots[index],
                        germinationTest: widget.germinationTest,
                        lastPage: lastPage,
                        isNewDay: widget.isNewDay,
                        onUpdatePage: () {
                          _pageViewController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar os dados: ${snapshot.error}'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
