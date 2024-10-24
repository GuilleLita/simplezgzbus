import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: Text('Simple ZGZ Bus'),
          centerTitle: false, // Center the title text
          backgroundColor: Colors.green, // Set the background color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          actions: [
           
            IconButton(
              icon: Icon(Icons.info_outlined),
              color: Colors.white,
              onPressed:  (){
                 
              },
            ),
          ],
        );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}