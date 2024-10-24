import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simplezgzbus/models/bus_stops.dart';

class ZGZApiService {
  static const String baseUrl = 'https://www.zaragoza.es/sede'; // Replace with your API base URL


  Future<List<BusStop>> fetchBusStops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/servicio/urbanismo-infraestructuras/transporte-urbano/poste-autobus.json?rf=html&srsname=wgs84&distance=4000')); // Replace 'endpoint' with your API endpoint
      if (response.statusCode == 200) {
        final bodyJson = json.decode(response.body);
        final results = bodyJson['result'];
        List<BusStop> toView = [];
        for (var i = 0; i < results.length; i++) {
          var busStopTitle = results[i]['title'];
          final finalNumberIndex = busStopTitle.indexOf(')'); // Find the index of the first ')'
          final openNumberIndex = busStopTitle.indexOf('('); // Find the index of the first '('
          var busStopNumber = busStopTitle.substring(openNumberIndex + 1, finalNumberIndex); // Extract the substring from the first '(' to the first ')';

          final lineaIndex = busStopTitle.indexOf('Línea'); // Find the index of the first 'Línea'
          var busStopName = busStopTitle.substring(finalNumberIndex + 2, lineaIndex-1);// Extract the substring from the first '.' to the first 'Línea';
          var busStop = BusStop(number: busStopNumber,name: busStopName);
          toView.add(busStop);
        }
        return toView;
      }
      else{
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List> fetchBusLines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/servicio/urbanismo-infraestructuras/transporte-urbano/linea-autobus.json?rf=html')); // Replace 'endpoint' with your API endpoint
      if (response.statusCode == 200) {
        final bodyJson = json.decode(response.body);
        final results = bodyJson['result'];
        var toView = [];
        for (var i = 0; i < results.length; i++) {
          var busLine = results[i].substring(96);
          toView.add(busLine);
        }
        return toView;
      }
      else{
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}