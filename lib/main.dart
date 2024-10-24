import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplezgzbus/screens/home_page.dart';
import 'package:simplezgzbus/screens/select_stop.dart';
import 'package:simplezgzbus/services/ZGZApiService.dart';
import 'package:simplezgzbus/models/bus_stops.dart';

void main() {
  getBusStops();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) {
            return SelectStopScreen(settings.arguments as List<dynamic>);
          },
        ),
      )
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}


getBusStops() async {
  var busStops = await ZGZApiService().fetchBusStops();
  busStopsNow = List.from(busStops);
}