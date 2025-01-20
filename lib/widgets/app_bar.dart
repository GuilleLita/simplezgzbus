import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  final PackageInfo packageInfo;
  MyAppBar({required this.packageInfo});
  
  @override
  Widget build(BuildContext context,) {
    
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      
                      title: Text('About Simple ZGZ Bus', textAlign: TextAlign.center,),
                      content: AboutText(packageInfo: packageInfo,),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
  }

  

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  
}

class AboutText extends StatelessWidget {
  final PackageInfo packageInfo ;

  const AboutText({Key? key, required this.packageInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Todos los datos son obtenidos del Ayuntamiento de Zaragoza\n\n",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Desarrollado por: \n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Guillermo Loscertales Litauszky\n\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: "Version: ${packageInfo.version}\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    WidgetSpan(
                      child: LinkButton(
                          urlLabel: "https://github.com/GuilleLita/simplezgzbus",
                          url: "https://github.com/GuilleLita/simplezgzbus"),
                    ),
                  ],
                ),
              )
          ],

                    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({Key? key, required this.urlLabel, required this.url})
      : super(key: key);

  final String urlLabel;
  final String url;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        minimumSize: const Size(0, 0),
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      onPressed: () {
        _launchUrl(url);
      },
      child: Text(urlLabel),
    );
  }
}