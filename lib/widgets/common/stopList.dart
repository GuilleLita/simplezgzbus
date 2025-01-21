import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';

class MyStopsList<T extends Widget,U extends Widget> extends StatefulWidget {
  final bool isDeleting;
  MyStopsList({Key? key, required this.isDeleting}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _MyStopsListState<T,U>();
  }
}

class _MyStopsListState<T extends Widget,U extends Widget> extends State<MyStopsList> {
  final MyStopsManagerNotifier _myStopsManagerNotifier = MyStopsManager.myStopsManagerNotifier;
  List<BusStop> myStops = myStopsNow;
  late T stopList;
  late U stopListInDelete;
  bool refreshBool = true;

  Future<void> _handleRefresh() async {
    
    setState(() {
      refreshBool = !refreshBool;
    });
  }



  @override
  Widget build(BuildContext context) {
    //TODO: If list emptry show a message
    print("Building MyStopsList isDeleting: ${widget.isDeleting}");
    return widget.isDeleting ? ListenableBuilder(
      listenable: _myStopsManagerNotifier,
      builder: (context, snapshot) => Container(
        constraints: BoxConstraints(
          minHeight: 200,
        ),
        child: stopListInDelete,
      )
    ) : 
    ListenableBuilder(
      listenable: _myStopsManagerNotifier,
      builder: (context, snapshot) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 200,
          ),
          child: RefreshIndicator(
            color: Colors.green,
            onRefresh: _handleRefresh,
            child: stopList,
          ),
        );
      }
    );
  }
}