import 'package:flutter/material.dart';
import 'package:simplezgzbus/widgets/app_bar.dart';
import 'package:simplezgzbus/widgets/transport_list.dart';

class SelectStopScreen extends StatelessWidget {

  final List<dynamic> stops;  

  SelectStopScreen(this.stops);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: TransportListWidget(stops),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
