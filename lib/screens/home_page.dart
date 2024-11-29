import 'package:flutter/material.dart';
import 'package:simplezgzbus/widgets/app_bar.dart';
import 'package:simplezgzbus/widgets/my_stops_list.dart';
import 'package:simplezgzbus/widgets/search_bar.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
  
}


class _MyHomePageState extends State<MyHomePage> {

  bool isSearching = false;

    handleClick() async {
      setState(() {
        isSearching = !isSearching;
      });
      print(isSearching);
    }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearching,
      onPopInvokedWithResult: (didPop, result) => didPop ?  null : handleClick() ,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: MyAppBar(),
          body: Column(
            children: [
              TabBar(tabs: [
                Tab(text: "Buses"),
                Tab(text: "Tranvia")
              ]),
              Expanded(
                flex: 1,
                child: TabBarView(
                  children: [
                    MyStopsList(),
                    Icon(Icons.tram)
                    //MyStopsList(),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    
                    children: [
                      isSearching ? StopSearchBar() : Container(),
                      IconButton(
                        iconSize: 50,
                        color: Colors.green,
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: handleClick,
                        
                      ),
                  
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}