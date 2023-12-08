import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'src/presentation/screens/battle_page_temp/engine/hybrid_engine.dart';
import 'src/presentation/screens/battle_page_temp/state_controllers/board_state.dart';
import 'src/presentation/screens/battle_page_temp/state_controllers/page_state.dart';
import 'src/presentation/screens/main_menu_screen/main_menu_screen.dart';
import 'src/utils/logging/prt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChessAppAi());
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  if (Platform.isAndroid) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  if (Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
  }
}

class ChessAppAi extends StatefulWidget {
  const ChessAppAi({super.key});

  static final navKey = GlobalKey<NavigatorState>();
  static get context => navKey.currentContext;

  @override
  State<ChessAppAi> createState() => _ChessAppAiState();
}

class _ChessAppAiState extends State<ChessAppAi> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Wakelock.enable();
    //checkTestAsyncFun();
    startUpEngine();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        Wakelock.enable();
        //Audios.loopBgm();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        //Audios.stopBgm();
        //HybridEngine().stop();
        Wakelock.disable();
        break;
      case AppLifecycleState.detached:
        //Audios.release();
        Wakelock.disable();
        //HybridEngine().shutdown();
        break;
      case AppLifecycleState.hidden:
        Wakelock.disable();
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BoardState>(create: (_) => BoardState()),
        ChangeNotifierProvider<PageState>(create: (_) => PageState()),
      ],
      child: MaterialApp(
        navigatorKey: ChessAppAi.navKey,
        theme: ThemeData(
          useMaterial3: true,
          //fontFamily: "Ios17Font",
          primarySwatch: Colors.brown,
        ),
        home: const Scaffold(body: MainMenuScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Future<void> startUpEngine() async {
    await HybridEngine().startup();
  }

  // void checkTestAsyncFun() async {
  //   final cchessEngine = CchessEngine();
  //   Future.delayed(const Duration(seconds: 1));
  //   prt("Jdt cchessEngine.startup()");
  //   await cchessEngine.startup();
  //   prt("Jdt cchessEngine.applyConfig()");
  //   await cchessEngine.applyConfig();
  //   prt("Jdt cchessEngine.applyConfig() done");
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
