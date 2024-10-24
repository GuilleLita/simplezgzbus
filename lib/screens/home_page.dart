import 'package:flutter/material.dart';
import 'package:simplezgzbus/models/bus_stops.dart';
import 'package:simplezgzbus/widgets/app_bar.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    handleClick() async {
      
      Navigator.pushNamed(context, '/selectStop', arguments: busStopsNow);
    }

    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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