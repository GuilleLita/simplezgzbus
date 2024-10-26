import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
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
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text("${stop.number} - ${stop.name}"),
      children: [
        Text(stop.number),
        Text(stop.id),
      ],
    );
  }
}
