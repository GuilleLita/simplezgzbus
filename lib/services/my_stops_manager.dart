import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

List<BusStop> myStopsNow = [];


class MyStopsManager  {
  static Database? _database;
  static final myStopsManagerNotifier = MyStopsManagerNotifier();

  static Future<void> openMyDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'my_stops2.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE my_stops(id STRING PRIMARY KEY, name TEXT, number TEXT)',
        );
      },
    );
  }

  static Future<void> closeDatabase() async {
    await _database?.close();
  }

  static Future<List<BusStop>> getMyStops() async {
    var query =_database!.query('my_stops');
    var stops = await query as List<Map<String, dynamic>>;
    return stops.map((stop) => BusStop(
      id: stop['id'],
      name: stop['name'],
      number: stop['number'],
    )).toList();
  }

  static Future<void> addStop(BusStop newBusStop) async {
    if (myStopsNow.contains(newBusStop)) {
      return;
    }
    await _database!.insert(
      'my_stops',
      {
        'name': newBusStop.name,
        'id': newBusStop.id,
        'number': newBusStop.number,
      },
    );
    myStopsNow.add(newBusStop);
    myStopsManagerNotifier.addStop(newBusStop);
  }

  static Future<void> deleteStop(String id) async {
    await _database!.delete(
      'my_stops',
      where: 'id = ?',
      whereArgs: [id],
    );
    myStopsNow.removeWhere((element) => element.id == id);
    myStopsManagerNotifier.deleteStop(id);
  }

  static Future<void> deleteAll() async {
    await _database!.delete('my_stops');
    myStopsNow.clear();
    myStopsManagerNotifier.deleteAll();
  }
}


class MyStopsManagerNotifier extends ChangeNotifier{
  List<BusStop> _myStops = myStopsNow;

  List<BusStop> get myStops => _myStops;

  void addStop(BusStop newBusStop) {
    log('Adding stop ${newBusStop.name}');
    _myStops.add(newBusStop);
    notifyListeners();
  }

  void deleteStop(String id) async {
    _myStops.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void deleteAll() async {
    _myStops.clear();
    notifyListeners();
  }
 
}