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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
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
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // La méthode build() est automatiquement appelée dès que les conditions
    // du widget changent.
    // Elle renvoit forcément à un widget ou à une arborescence de widget imbriqués.

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        // Placeholder insère un rectangle barré pour marquer un UI pas encore dev
        break;
      default:
        throw UnimplementedError('no widget fo $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      //permet de rendre l'app responsive
      return Scaffold(
        // Scaffold est utilisé pour le widget de 1er niveau
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("' Please don't die !! '",
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        ),

        body: Row(
          children: [
            SafeArea(
              // SafeArea garantit que l'enfant ne sera pas masqué
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text('Favorites')),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                    // This call to setState tells the Flutter framework that something
                    // has changed in this State, which causes it to rerun the build
                    // method below so that the display can reflect the updated values.
                    // Without setState(), the build method would not be
                    // called again, and so nothing would appear to happen.
                  });
                },
              ),
            ),
            Expanded(
              // Expanded prendra un max de place
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // la méthode watch() suit les modifs de l'état.
    var pair = appState.current;

    final theme = Theme.of(context);
    // appelle le theme de l'app
    final titleStyle = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.primary,
    );

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Plant's name idea:",
          style: titleStyle,
        ),
        SizedBox(height: 40),
        BigCard(pair: pair),
        SizedBox(height: 40),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text(
                'Love it !',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 40),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text(
                'Unsatisfied',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ]),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: '${pair.first} ${pair.second}',
          // accessibilité : permet de s'assurer de la bonne prononciation
          // des mots par un lecteur d'écran
        ),
      ),
    );
  }
}
