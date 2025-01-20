import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/tram_stops.dart';
import 'package:simplezgzbus/services/ZGZApiService.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';

class TramStopsListWidget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _TramStopsListWidgetState();
  }
}

class _TramStopsListWidgetState extends State<TramStopsListWidget> {
  final MyStopsManagerNotifier _myStopsManagerNotifier = MyStopsManager.myStopsManagerNotifier;
  List<TramStop> myStops = tramStopsNow;
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
              itemCount: _myStopsManagerNotifier.myTramStops.length,
              itemBuilder: (context, index) {
                Stop aux = Stop(_myStopsManagerNotifier.myTramStops[index], key: ValueKey(refreshBool));
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
  final TramStop stop;

  Stop(this.stop, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StopSate();
  }
}


class _StopSate extends State<Stop> {
  late Future<NexTrams> future;

  void onTap(stop){
    //Expand card
    print(stop);
  }

  @override
  void initState() {
    super.initState();
    future = fetchTimes(widget.stop);
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
}


Future<NexTrams> fetchTimes(TramStop stop) async {
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