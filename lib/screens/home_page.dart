import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simplezgzbus/widgets/app_bar.dart';
import 'package:simplezgzbus/widgets/my_busstops_list.dart';
import 'package:simplezgzbus/widgets/my_tramstops_list.dart';
import 'package:simplezgzbus/widgets/search_bar.dart';

class MyHomePage extends StatefulWidget {

  final PackageInfo packageInfo;
  MyHomePage({required this.packageInfo});

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
  
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  late PackageInfo packageInfo;
  _MyHomePageState();
  bool isSearching = false;
  late TabController _tabController;
  int _selectedIndex = 0;
  late FocusNode myFocusNode;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, animationDuration: Duration(milliseconds: 100));
    packageInfo = widget.packageInfo;
    _tabController.addListener(_handleTabSelection);
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    
    setState(() {
      _selectedIndex = _tabController.index;
      isSearching = false;
    });
  }

    handleClick() async {
      myFocusNode.requestFocus();
      setState(() {
        isSearching = !isSearching;
        isDeleting = false;
      });
      print(isSearching);
    }

    handleDelClick() async {
      setState(() {
        isDeleting = !isDeleting;
      });
      print(isDeleting);
    }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearching,
      onPopInvokedWithResult: (didPop, result) => didPop ?  null : handleClick() ,
        child: GestureDetector(
          onTap: () {
            print("Tapped isSearching: $isSearching");
            if(isSearching) {
              FocusScope.of(context).unfocus();
              handleClick();
            }
            if(isDeleting) {
              handleDelClick();
            }
          },
          child: Scaffold(
            appBar: MyAppBar(packageInfo: packageInfo),
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
                  child: 
                  Scaffold(
                         floatingActionButton: !isSearching  ? AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: isSearching ? 0.0 : 1.0,
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                heroTag: "btn1",
                                onPressed: () {
                                  !isSearching ? handleClick() : null;
                                },
                                child: Icon(Icons.add),
                              ),
                              SizedBox(width: 10,),
                              FloatingActionButton(
                                heroTag: "btn2",
                                onPressed: () {
                                  !isSearching ? handleDelClick() : null;
                                },
                                child: Icon(Icons.delete),
                              ),
                            ],
                                                 ),
                         ): null,
                        floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
                        body: TabBarView(
                          controller: _tabController,
                          children: [
                            MyStopsList(isDeleting: isDeleting),
                            TramStopsListWidget(isDeleting: isDeleting,)
                          ],
                        ),
                    ),   
                  ),
                Expanded(
                  flex: 0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isSearching ? StopSearchBar(_selectedIndex, myFocusNode) : Container(),
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