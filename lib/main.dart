import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/infra/config/notification_local_service.dart';
import 'package:flutter_seedbyseed/interface/screens/add_germinated_seeds.dart';
import 'package:flutter_seedbyseed/interface/screens/add_germination_test.dart';
import 'package:flutter_seedbyseed/interface/screens/details_germination_test.dart';
import 'package:flutter_seedbyseed/interface/widget/finished_tab.dart';
import 'package:flutter_seedbyseed/interface/widget/progress_tab.dart';
import 'package:flutter_seedbyseed/infra/route/routes.dart';
import 'package:flutter_seedbyseed/persistence/repository/germination_test_repository.dart';
import 'package:flutter_seedbyseed/persistence/repository/lot_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  await NotificationLocalService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GerminationTestRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => LotRepository(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeedBySeed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      // Define os locales suportados pelo seu app
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'), // Português, Brasil
        // Adicione outros locales se seu app for multi-idioma
      ],
      routes: {
        PageRoutes.kHOME: (context) => const HomePage(),
        PageRoutes.kADD_GERMINATIONTEST: (context) =>
            const AddGerminationTest(),
        PageRoutes.kADD_GERMINATEDSEEDS: (context) =>
            const AddGerminatedSeeds(),
        PageRoutes.kDETAILS_GERMINATIONTEST: (context) =>
            const DetailsGerminationTest(),
        PageRoutes.kUPDATE_GERMINATIONTEST: (context) {
          final test =
              ModalRoute.of(context)!.settings.arguments as GerminationTest;
          return AddGerminationTest(testToEdit: test);
        },
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //GerminationTest.totalUngerminatedSeed();
    //GerminationTest.calculateMeanRepetition();

    return Scaffold(
      // TODO: CRIAR UM COMPONENT PARA APPBAR
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Seed',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 64, 104, 25),
                ),
              ),
              TextSpan(
                text: ' By ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 94, 55, 31),
                ),
              ),
              TextSpan(
                text: 'Seed',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 34, 167, 195),
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            text: "Em Andamento",
          ),
          Tab(
            text: "Concluído",
          )
        ]),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [ProgressTab(), FinishedTab()]),
    );
  }
}
