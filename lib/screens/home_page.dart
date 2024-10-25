import 'package:flutter/material.dart';
import 'package:simplezgzbus/widgets/app_bar.dart';
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
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
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
    );
  }
}