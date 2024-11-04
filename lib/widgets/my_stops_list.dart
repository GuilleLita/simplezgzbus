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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _myStopsManagerNotifier,
      builder: (context, snapshot) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 200,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _myStopsManagerNotifier.myStops.length,
            itemBuilder: (context, index) {
              return Stop(_myStopsManagerNotifier.myStops[index]);
            },
          ),
        );
      }
    );
  }
}


class Stop extends StatelessWidget {
  final BusStop stop;

  void onTap(stop){
    //Expand card
    print(stop);
  }

  Stop(this.stop);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NextDestination>>(
      future: fetchTimes(stop.id),
      builder: (context, snapshot) => 
        snapshot.hasData ? 
          Card(
            
            elevation: 0,
            margin: EdgeInsets.all(0),
            child: ExpansionTile(
              backgroundColor: Color.fromARGB(255, 237, 237, 237),
              initiallyExpanded: true,
              leading: Icon(Icons.directions_bus),
              title: Text(stop.name),
              
              children: [  
                for (var time in snapshot.data!) 
                  ListTile(
                    title: Text("${time.number} ${time.direccion}"),
                    subtitle: Text("${time.first_time}"),
                  )
              ],
            ),
          ) : 
          Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            child: ListTile(
              tileColor: Color.fromARGB(255, 237, 237, 237),
              onTap: () => onTap(stop),
              leading: Icon(Icons.directions_bus),
              title: Text(stop.name),
              subtitle: Text('Cargando...'),
            ),
          ),
      
    );
  }
}


Future<List<NextDestination>> fetchTimes(String id) async {
  List<NextDestination> retValue = [];
  for (var i = 0; i < 5; i++) {
    retValue = await ZGZApiService().fetchBusWait(id);
    if (retValue.isNotEmpty) {
      break;
    }
    else {
      await Future.delayed(Duration(seconds: 1));
    }
  }
  return retValue;
}