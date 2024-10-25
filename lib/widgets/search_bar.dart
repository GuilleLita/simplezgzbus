import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/widgets/transport_list.dart';

class StopSearchBar extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StopSearchBarState();
  }

  
}

class _StopSearchBarState extends State<StopSearchBar> {

  bool isSearching = false;
  String input = '';

  void _search() async {
    if(input.isNotEmpty) {
      var displayedBusStops = busStopsNow.where((element) => element.toString().toLowerCase().contains(input.toLowerCase())).toList();

       setState(() {
        isSearching = true;
        busStops =  displayedBusStops;
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
    print('Searching...');
  }

  List<BusStop> busStops = [BusStop(number: "1",name: 'Paseo Independencia'), BusStop(number: "20", name: 'Plaza España')];

  @override
  Widget build(BuildContext context) {
    return
         Column(
           children: [
            isSearching ?  TransportListWidget(busStops, 355) : Container() ,
             Row(
               children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 330,
                      child: TextField(
                        onChanged: (value) {
                          input = value;
                        },
                        onSubmitted: (value) {
                          _search();
                        },
                        decoration: InputDecoration(
                          hintText: 'Nº de parada...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _search,
                  ),
               ],
             ),
           ],
         ); 
  }
}