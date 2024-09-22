import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/page/add_germination_test.dart';
import 'package:flutter_seedbyseed/interface/widget/completed_tab.dart';
import 'package:flutter_seedbyseed/interface/widget/progress_tab.dart';
import 'package:flutter_seedbyseed/route/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SeedBySeed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routes: {
        PageRoutes.kHOME: (context) => const HomePage(),
        PageRoutes.kADD_GERMINATIONTEST: (context) =>
            const AddGerminationTest(),
        //PageRoutes.kUPDATE_GERMINATIONTEST: (context) => const UpdateGerminationTest(),
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
    return Scaffold(
      // TODO: CRIAR UM COMPONENT PARA APPBAR
      appBar: AppBar(
        title: const Text("SeedBySeed"),
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
          children: const [ProgressTab(), CompletedTab()]),
    );
  }
}
