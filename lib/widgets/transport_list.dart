import 'package:flutter/material.dart';

class TransportListWidget extends StatelessWidget {
  final List<dynamic> transportList;

  TransportListWidget(this.transportList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transportList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(transportList[index].toString()),
        );
      },
    );
  }
}

