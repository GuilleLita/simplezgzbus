import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simplezgzbus/services/my_stops_manager.dart';

class TransportListWidget extends StatelessWidget implements PreferredSizeWidget {
  final List<dynamic> transportList;

  final double width;
  final Function selected;

  void onTap(stop){
    MyStopsManager.addStop(stop);
    selected();
    print(stop);
  }

  TransportListWidget(this.transportList, this.width, this.selected);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        constraints: BoxConstraints(
                      minWidth: double.infinity,
                      maxHeight: 200,
                    ),
                    margin: EdgeInsets.only(bottom: 3, top: 3, left: 10, right: 10),
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(0),
        clipBehavior: Clip.hardEdge,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: transportList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                tileColor: ((index%2 == 0) ? Color.fromARGB(255, 237, 237, 237) : Color(0xFFFFFFFF)),
                onTap: () => onTap(transportList[index]),
                leading: Icon(Icons.directions_bus),
                title: Text(transportList[index].toString()),
              ),
            );
          },
        ),
      );
  }

  @override
  Size get preferredSize => Size.fromWidth(width);
}

