import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simplezgzbus/models/bus_line.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/models/tram_stops.dart';

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
          var busStop = BusStop(number: busStopNumber,name: busStopName, id: results[i]['id']);
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

  Future<List<NextDestination>> fetchBusWait(idStop) async{
    try {
      final response = await http.get(Uri.parse('$baseUrl/servicio/urbanismo-infraestructuras/transporte-urbano/poste-autobus/$idStop.json?rf=html&srsname=wgs84'));
      if (response.statusCode == 200) {
        final bodyJson = json.decode(response.body);
        final results = bodyJson['destinos'];
        List<NextDestination> toView = [];
        for (var i = 0; i < results.length; i++) {
          var busDestination = NextDestination(number: results[i]['linea'], direccion: results[i]['destino'], first_time:  results[i]['primero'], last_time:  results[i]['segundo']);
          
          toView.add(busDestination);
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

  Future<List<TramStop>> fetchTramStops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/servicio/urbanismo-infraestructuras/transporte-urbano/parada-tranvia.json?rf=html&srsname=wgs84&distance=4000')); // Replace 'endpoint' with your API endpoint
      if (response.statusCode == 200) {
        final bodyJson = json.decode(response.body);
        final results = bodyJson['result'];
        List<TramStop> toView = [];
        
        for (var i = 0; i < results.length; i++) {
          var tramStopName = results[i]['title'];
          var auxStop = TramStop(name: tramStopName, id: results[i]['id']);
          if(toView.contains(auxStop)){
            toView[toView.indexOf(auxStop)].id2 = results[i]['id'];
            continue;
          }
          toView.add(auxStop);
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

  Future<NexTrams> fetchTramWait(TramStop stop) async {
    try {
      final String idStop1 = stop.id;
      
      final response = await http.get(Uri.parse('$baseUrl/servicio/urbanismo-infraestructuras/transporte-urbano/parada-tranvia/$idStop1.json?rf=html&srsname=wgs84'));
       
      if (response.statusCode == 200) {
        final bodyJson = json.decode(response.body);
        final results = bodyJson['destinos'];
        List<NexTrams> toView = [];
        if(results.length == 0){
          return NexTrams(name: stop.name, direction1: 'No hay datos', time_direction1: 'No hay datos');
        }
        var tramDestination = NexTrams(name: stop.name, direction1: results[0]['destino'], time_direction1:  results[0]['minutos'].toString());
        tramDestination.numOfdirections++;
        if(results.length == 2) {
          tramDestination.second_time_direction1 = results[1]['minutos'].toString();
        }
        if(stop.id2 != ""){
          final String idStop2 = stop.id2;
          final response2 = await http.get(Uri.parse('$baseUrl/servicio/urbanismo-infraestructuras/transporte-urbano/parada-tranvia/$idStop2.json?rf=html&srsname=wgs84'));
          if (response2.statusCode == 200) {
            final bodyJson2 = json.decode(response2.body);
            final results2 = bodyJson2['destinos'];
            if(results2.length == 1) {
              tramDestination.numOfdirections++;
              tramDestination.direction2 = results2[0]['destino'];
              tramDestination.time_direction2 = results2[0]['minutos'].toString();
            }
            else if(results2.length == 2) {
              tramDestination.numOfdirections++;
              tramDestination.direction2 = results2[0]['destino'];
              tramDestination.time_direction2 = results2[0]['minutos'].toString();
              tramDestination.second_time_direction2 = results2[1]['minutos'].toString();
            }
          }
        }
        return tramDestination;
      }
      else{
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print(e);
      return NexTrams(name: stop.name, direction1: 'No hay datos', time_direction1: 'No hay datos');
    }
  }
}