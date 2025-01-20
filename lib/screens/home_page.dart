import 'package:flutter/material.dart';
import 'package:simplezgzbus/widgets/app_bar.dart';
import 'package:simplezgzbus/widgets/my_busstops_list.dart';
import 'package:simplezgzbus/widgets/my_tramstops_list.dart';
import 'package:simplezgzbus/widgets/search_bar.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
  
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  bool isSearching = false;
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, animationDuration: Duration(milliseconds: 100));

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    
    setState(() {
      _selectedIndex = _tabController.index;
      isSearching = false;
    });
  }

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
        child: Scaffold(
          appBar: MyAppBar(),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Buses"),
                  Tab(text: "Tranvia")
              ]),
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MyStopsList(),
                    TramStopsListWidget(),
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
                      isSearching ? StopSearchBar(_selectedIndex) : Container(),
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
    );
  }
}