import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Plant namer app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // l'état d'intégrité de l'app, c'est-à-dire les données dont elle a besoin.
  // Le "ChangeNotifier" permet d'informer les autres widgets de ces modifs,
  // l'état est transmis via le ChangeNotifierProvider qui est dans MyApp.
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
    // NotifyListeners() garantit que tout ce qui "surveille" MyAppState soit informé.
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values
  // provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void _incrementCounter() {
  //   setState(() {
  // This call to setState tells the Flutter framework that something has
  // changed in this State, which causes it to rerun the build method below
  // so that the display can reflect the updated values. If we changed
  // _counter without calling setState(), then the build method would not be
  // called again, and so nothing would appear to happen.
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // La méthode build() est automatiquement appelée dès que les conditions
    // du widget changent.
    // Elle renvoit forcément à un widget ou à une arborescence de widget imbriqués.
    var appState = context.watch<MyAppState>();
    // la méthode watch() suit les modifs de l'état.
    return Scaffold(
      // Scaffold est utilisé pour le widget de 1er niveau
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("'Please don't die !!'"),
      ),
      body: Column(
        // Column is a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        children: [
          Text("Plant's name idea:"),
          Text(appState.current.asPascalCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Unsatisfied'),
          )
        ],
      ),
    );
  }
}
