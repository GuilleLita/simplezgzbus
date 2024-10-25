import 'package:flutter/material.dart';

class TransportListWidget extends StatelessWidget implements PreferredSizeWidget {
  final List<dynamic> transportList;
  final double width;

  TransportListWidget(this.transportList, this.width);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        constraints: BoxConstraints(
          maxHeight: 200,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: transportList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(transportList[index].toString()),
            );
          },
        ),
      );
  }

  @override
  Size get preferredSize => Size.fromWidth(width);
}

