import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';
import 'package:simplezgzbus/widgets/common/stops.dart';

class MyStopsList extends StatefulWidget {
  final bool isDeleting;
  MyStopsList({Key? key, required this.isDeleting}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _MyStopsListState();
  }
}

class _MyStopsListState extends State<MyStopsList> {
  final MyStopsManagerNotifier _myStopsManagerNotifier = MyStopsManager.myStopsManagerNotifier;
  List<BusStop> myStops = myStopsNow;
  bool refreshBool = true;

  Future<void> _handleRefresh() async {
    
    setState(() {
      refreshBool = !refreshBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: If list emptry show a message
    
    return 
     ListenableBuilder(
      listenable: _myStopsManagerNotifier,
      builder: (context, snapshot) {
        return _myStopsManagerNotifier.myBusStops.isEmpty ? Center(child: Text('No hay paradas añadidas.\nPulsa el boton + de abajo para añadir una.', textAlign: TextAlign.center),) :
         Container(
          constraints: BoxConstraints(
            minHeight: 200,
          ),
          child: RefreshIndicator(
            color: Colors.green,
            onRefresh: _handleRefresh,
            child: widget.isDeleting ? ListOfBusStopsInDelete(stops: _myStopsManagerNotifier.myBusStops) 
                                     : ListOfBusStops(stops: _myStopsManagerNotifier.myBusStops, refreshBool: refreshBool),
          ),
        );
      }
    );
  }
}
