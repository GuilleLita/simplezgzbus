import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_line.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/services/ZGZApiService.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';
import 'package:simplezgzbus/models/tram_stops.dart';


class BusStopWidget extends StatefulWidget {
  final BusStop stop;

  BusStopWidget(this.stop, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BusStopSate();
  }
}

class _BusStopSate extends State<BusStopWidget> {
  late Future<List<NextDestination>> future;

  void onTap(stop){
    //Expand card
    print(stop);
  }

  @override
  void initState() {
    super.initState();
    future = fetchBusTimes(widget.stop.id);
  }


  @override
  Widget build(BuildContext context) {
      return FutureBuilder<List<NextDestination>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                tileColor: Color.fromARGB(255, 237, 237, 237),
                onTap: () => onTap(widget.stop),
                leading: Icon(Icons.directions_bus),
                title: Text(widget.stop.name),
                subtitle: Text('Cargando...'),
                
              ),
            );
          default:
            if (snapshot.hasError) {
              return Card(
                elevation: 0,
                margin: EdgeInsets.all(0),
                child: ListTile(
                  tileColor: Color.fromARGB(255, 237, 237, 237),
                  onTap: () => onTap(widget.stop),
                  leading: Icon(Icons.directions_bus),
                  title: Text(widget.stop.name),
                  subtitle: Text('Error al cargar los datos'),
                ),
              );
            }
            else {
              return
              Card(
                
                elevation: 0,
                margin: EdgeInsets.all(0),
                child: ExpansionTile(
                  
                  backgroundColor: Color.fromARGB(255, 237, 237, 237),
                  initiallyExpanded: true,
                  leading: Icon(Icons.directions_bus),
                  title: Text(widget.stop.name),
                  onExpansionChanged: (isExpanded) => onTap(widget.stop),
                  children: [  
                    for (var time in snapshot.data!) 
                      ListTile(
                        title: Text("${time.number} ${time.direccion}"),
                        subtitle: Text(time.first_time),
                      )
                  ],
                ),
              ) ;
            }
        }
      }

    );
  }


  Future<List<NextDestination>> fetchBusTimes(String id) async {
    List<NextDestination> retValue = [];
    for (var i = 0; i < 5; i++) {
      print('Fetching times...');
      retValue = await ZGZApiService().fetchBusWait(id);

      if (retValue.isNotEmpty) {
        break;
      }
      else {
        print('Retrying...');
        await Future.delayed(Duration(seconds: 1));
      }
    }
    return retValue;
  }
}


class ListOfBusStops extends StatelessWidget {
  final List<BusStop> stops;
  final bool refreshBool;

  ListOfBusStops({Key? key, required this.stops, required this.refreshBool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building MyStopsList ");
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, index) {
        return BusStopWidget(stops[index], key: ValueKey(refreshBool));
      },
    );
  }
  }




class BusStopInDelete extends StatefulWidget {
  final BusStop stop;
 
  BusStopInDelete(this.stop, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BusStopInDeleteState();
  }
}

class _BusStopInDeleteState extends State<BusStopInDelete> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: ListTile(
        tileColor: Color.fromARGB(255, 237, 237, 237),
        onTap: () => print(widget.stop),
        
        leading: Icon(Icons.directions_bus),
        title: Text(widget.stop.name),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            MyStopsManager.deleteStop(widget.stop.id);
          },
        ),
      ),
    );
  }
}

class ListOfBusStopsInDelete extends StatelessWidget {
  final List<BusStop> stops;

  ListOfBusStopsInDelete( {Key? key, required this.stops,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, index) {
        return BusStopInDelete(stops[index]);
      },
    );
  }
}


class TramStopWidget extends StatefulWidget {
  final TramStop stop;

  TramStopWidget(this.stop, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TramStopSate();
  }
}

class _TramStopSate extends State<TramStopWidget> {
  late Future<NexTrams> future;

  void onTap(stop){
    //Expand card
    print(stop);
  }

  @override
  void initState() {
    super.initState();
    future = fetchTramTimes(widget.stop);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NexTrams>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                tileColor: Color.fromARGB(255, 237, 237, 237),
                onTap: () => onTap(widget.stop),
                leading: Icon(Icons.tram),
                title: Text(widget.stop.name),
                subtitle: Text('Cargando...'),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Card(
                elevation: 0,
                margin: EdgeInsets.all(0),
                child: ListTile(
                  tileColor: Color.fromARGB(255, 237, 237, 237),
                  onTap: () => onTap(widget.stop),
                  leading: Icon(Icons.tram),
                  title: Text(widget.stop.name),
                  subtitle: Text('Error al cargar los datos'),
                ),
              );
            }
            else {
              return
              Card(
                elevation: 0,
                margin: EdgeInsets.all(0),
                child: ExpansionTile(
                  backgroundColor: Color.fromARGB(255, 237, 237, 237),
                  initiallyExpanded: true,
                  leading: Icon(Icons.tram),
                  title: Text(widget.stop.name),
                  onExpansionChanged: (isExpanded) => onTap(widget.stop),
                  children: [
                    ListTile(
                      tileColor: Color.fromARGB(255, 237, 237, 237),
                      title: Text(snapshot.data!.direction1),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${snapshot.data!.time_direction1} min'),
                          Text('${snapshot.data!.second_time_direction1} min'),
                        ],
                      ),
                    ),
                    if (snapshot.data!.numOfdirections > 1)
                      ListTile(
                        tileColor: Color.fromARGB(255, 237, 237, 237),
                        title: Text(snapshot.data!.direction2),
                        subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${snapshot.data!.time_direction2} min'),
                          Text('${snapshot.data!.second_time_direction2} min'),
                        ],
                      ),
                      ),
                  ],
                ),
              ) ;
            }
        }
      }

    );
  }

  Future<NexTrams> fetchTramTimes(TramStop stop) async {
    NexTrams retValue = NexTrams(name: stop.name, direction1: 'No hay datos', time_direction1: 'No hay datos');
    for (var i = 0; i < 5; i++) {
      print('Fetching times...');
      retValue = await ZGZApiService().fetchTramWait(stop);
      print(retValue);
      if (retValue.direction1 != 'No hay datos') {
        break;
      }
      else {
        print('Retrying...');
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
    return retValue;
  }
}


class ListOfTramStops extends StatelessWidget {
  final List<TramStop> stops;
  final bool refreshBool;

  ListOfTramStops( {Key? key, required this.stops, required this.refreshBool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, index) {
        return TramStopWidget(stops[index], key: ValueKey(refreshBool),);
      },
    );
  }
}


class TramStopInDelete extends StatefulWidget {
  final TramStop stop;
 
  TramStopInDelete(this.stop, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TramStopInDeleteState();
  }
}

class _TramStopInDeleteState extends State<TramStopInDelete> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: ListTile(
        tileColor: Color.fromARGB(255, 237, 237, 237),
        onTap: () => print(widget.stop),
        
        leading: Icon(Icons.tram),
        title: Text(widget.stop.name),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            MyStopsManager.deleteTramStop(widget.stop.id);
          },
        ),
      ),
    );
  }
}

class ListOfTramStopsInDelete extends StatelessWidget {
  final List<TramStop> stops;

  ListOfTramStopsInDelete( {Key? key, required this.stops}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, index) {
        return TramStopInDelete(stops[index]);
      },
    );
  }
}

