import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/models/tram_stops.dart';
import 'package:simplezgzbus/widgets/transport_list.dart';

class StopSearchBar extends StatefulWidget {
  final int tabIndex;
  final FocusNode focusNode;
  StopSearchBar(this.tabIndex, this.focusNode , {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StopSearchBarState();
  }

  
}

class _StopSearchBarState extends State<StopSearchBar> {
  
  bool isSearching = false;
  String input = '';
  List stops = [];
  final textController = TextEditingController();

  void _search(context) async {
    bool isTramTab = widget.tabIndex == 1;
    if(input.isNotEmpty) {
      var displayedBusStops = isTramTab ? tramStopsNow.where((element) => element.toString().toLowerCase().contains(input.toLowerCase())).toList() :
                                          busStopsNow.where((element) => element.toString().toLowerCase().contains(input.toLowerCase())).toList();

       setState(() {
        isSearching = true;
        stops =  displayedBusStops;
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
    print('Searching...');
  }

  void _clear() async {
    setState(() {
      isSearching = false;
      input = '';
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return
         PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) => didPop ?  null: _clear(),
           child: Column(
             children: [
              (isSearching && stops.isNotEmpty) ?  
                  TransportListWidget(stops, 355, () => _clear(), widget.tabIndex == 1) : //Se muestra la lista de paradas si se ha buscado algo y se han encontrado paradas
                  isSearching ? 
                    Container(             //Se muestra un mensaje si no se han encontrado paradas
                      constraints: BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 3, top: 3, left: 10, right: 10),
                      decoration: BoxDecoration(
                                    border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                      child: Text("No se han encotrado paradas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ) : Container(), //Si no se ha buscado nada no se muestra nada
               Row(
                 children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: SizedBox(
                        width: 330,
                        child: TextField(
                          focusNode: widget.focusNode,
                          controller: textController,
                          onChanged: (value) {
                            input = value;
                          },
                          onSubmitted: (value) {
                            _search(context);
                          },
                          decoration: InputDecoration(
                            hintText: 'Nº de parada...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => _search(context),
                    ),
                 ],
               ),
             ],
           ),
         ); 
  }
}