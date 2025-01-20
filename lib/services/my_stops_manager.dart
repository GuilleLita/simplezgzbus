import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/models/tram_stops.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

List<BusStop> myStopsNow = [];
List<TramStop> myTramStopsNow = [];


class MyStopsManager  {
  static Database? _database;
  static final myStopsManagerNotifier = MyStopsManagerNotifier();

  static Future<void> openMyDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'my_stops.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE my_bus_stops(id STRING PRIMARY KEY, name TEXT, number TEXT)',
        );
        return db.execute(
          'CREATE TABLE my_tram_stops(name TEXT PRIMARY KEY, id TEXT, id2 TEXT)',
        );
        
      },
    );
  }

  static Future<void> closeDatabase() async {
    await _database?.close();
  }

  static Future<List<BusStop>> getMyStops() async {
    var query =_database!.query('my_bus_stops');
    var stops = await query as List<Map<String, dynamic>>;
    return stops.map((stop) => BusStop(
      id: stop['id'],
      name: stop['name'],
      number: stop['number'],
    )).toList();
  }

  static Future<List<TramStop>> getMyTramStops() async {
    var query =_database!.query('my_tram_stops');
    var stops = await query as List<Map<String, dynamic>>;
    return stops.map((stop) => TramStop(
      id: stop['id'],
      name: stop['name'],
      id2: stop['id2'],
    )).toList();
  }

  static Future<void> addStop(BusStop newBusStop) async {
    
    if (myStopsNow.contains(newBusStop)) {
      return;
    }
    print('Adding stop' + newBusStop.name);
    await _database!.insert(
      'my_bus_stops',
      {
        'name': newBusStop.name,
        'id': newBusStop.id,
        'number': newBusStop.number,
      },
    );
    myStopsNow.add(newBusStop);
    myStopsManagerNotifier.addStop(newBusStop);
  }

  static Future<void> addTramStop(TramStop newTramStop) async {
    if (myTramStopsNow.contains(newTramStop)) {
      return;
    }
    await _database!.insert(
      'my_tram_stops',
      {
        'name': newTramStop.name,
        'id': newTramStop.id,
        'id2': newTramStop.id2
      },
    );
    myTramStopsNow.add(newTramStop);
    myStopsManagerNotifier.addTramStop(newTramStop);
  }

  static Future<void> deleteStop(String id) async {
    await _database!.delete(
      'my_bus_stops',
      where: 'id = ?',
      whereArgs: [id],
    );
    myStopsNow.removeWhere((element) => element.id == id);
    myStopsManagerNotifier.deleteStop(id);
  }

  static Future<void> deleteAll() async {
    await _database!.delete('my_bus_stops');
    myStopsNow.clear();
    myStopsManagerNotifier.deleteAll();
  }
}


class MyStopsManagerNotifier extends ChangeNotifier{

  List<BusStop> get myStops => myStopsNow;
  List<TramStop> get myTramStops => myTramStopsNow;

  void addStop(BusStop newBusStop) {
    
    //_myStops.add(newBusStop);
    notifyListeners();
  }

  void addTramStop(TramStop newTramStop) {
    //_myTramStops.add(newTramStop);
    notifyListeners();
  }

  void deleteStop(String id) async {
    //_myStops.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void deleteAll() async {
    //_myStops.clear();
    notifyListeners();
  }
 
}