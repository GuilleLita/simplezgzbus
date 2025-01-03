import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_line.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/services/ZGZApiService.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';

class MyStopsList extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _MyStopsListState();
  }
}

class _MyStopsListState extends State<MyStopsList> {
  final MyStopsManagerNotifier _myStopsManagerNotifier = MyStopsManager.myStopsManagerNotifier;
  List<BusStop> myStops = myStopsNow;
  List<Stop> stopWidgets = [];
  bool refreshBool = true;


  Future<void> _handleRefresh() async {
    
    setState(() {
      refreshBool = !refreshBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _myStopsManagerNotifier,
      builder: (context, snapshot) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 200,
          ),
          child: RefreshIndicator(
            color: Colors.green,
            onRefresh: _handleRefresh,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _myStopsManagerNotifier.myStops.length,
              itemBuilder: (context, index) {
                Stop aux = Stop(_myStopsManagerNotifier.myStops[index], key: ValueKey(refreshBool));
                stopWidgets.add(aux);
                return aux;
              },
            ),
          ),
        );
      }
    );
  }
}


class Stop extends StatefulWidget {
  final BusStop stop;

  Stop(this.stop, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StopSate();
  }
}


class _StopSate extends State<Stop> {
  late Future<List<NextDestination>> future;

  void onTap(stop){
    //Expand card
    print(stop);
  }

  @override
  void initState() {
    super.initState();
    future = fetchTimes(widget.stop.id);
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
}


Future<List<NextDestination>> fetchTimes(String id) async {
  List<NextDestination> retValue = [];
  for (var i = 0; i < 5; i++) {
    print('Fetching times...');
    retValue = await ZGZApiService().fetchBusWait(id);
    print(retValue.first);
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