import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplezgzbus/screens/home_page.dart';
import 'package:simplezgzbus/screens/select_stop.dart';
import 'package:simplezgzbus/screens/splash_screen.dart';
import 'package:simplezgzbus/services/ZGZApiService.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';

void main() {
  initApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: FutureBuilderApp(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class FutureBuilderApp extends StatefulWidget {
  const FutureBuilderApp({super.key});

  @override
  State<FutureBuilderApp> createState() => _FutureBuilderAppState();
}

class _FutureBuilderAppState extends State<FutureBuilderApp> {
  

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: initApp(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return ChangeNotifierProvider(
            create: (context) => MyAppState(),
            child: MaterialApp(
              title: 'Simple Zgz Bus',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
              ),
              home: MyHomePage(),
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) {
                  return MyHomePage();
                  //return SelectStopScreen(settings.arguments as List<dynamic>);
                },
              ),
            )
          );
          } else if (snapshot.hasError) {
            //TODO: Show error message
              return SplashScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}



Future<String> initApp() async {
  var clock = DateTime.now();
  var busStops = await ZGZApiService().fetchBusStops();
  await MyStopsManager.openMyDatabase();
  myStopsNow = await MyStopsManager.getMyStops();
  var clock2 = DateTime.now();

  var diff = clock2.difference(clock);
  busStopsNow = List.from(busStops);
  if(diff.inSeconds < 2) {
    await Future.delayed(Duration(seconds: 2));
  }
  
  return 'Success';
}