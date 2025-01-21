import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/tram_stops.dart';
import 'package:simplezgzbus/widgets/common/stops.dart';
import 'package:simplezgzbus/services/ZGZApiService.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';

class TramStopsListWidget extends StatefulWidget {
  final bool isDeleting;

  TramStopsListWidget({Key? key, required this.isDeleting}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _TramStopsListWidgetState();
  }
}

class _TramStopsListWidgetState extends State<TramStopsListWidget> {
  final MyStopsManagerNotifier _myStopsManagerNotifier = MyStopsManager.myStopsManagerNotifier;
  List<TramStop> myStops = tramStopsNow;
  bool refreshBool = true;

  Future<void> _handleRefresh() async {
    setState(() {
      refreshBool = !refreshBool;
    });
  }

  @override
  Widget build(BuildContext context) {

    return

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
            child: widget.isDeleting ? ListOfTramStopsInDelete(stops: _myStopsManagerNotifier.myTramStops) 
                                     : ListOfTramStops(stops: _myStopsManagerNotifier.myTramStops, refreshBool: refreshBool),
          ),
        );
      }
    );
  }
}
