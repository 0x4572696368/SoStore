import 'package:app/flPiker.dart';
import 'package:app/load.dart';
import 'package:app/pages/homePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        backgroundColor: Colors.transparent,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0.15)),
        // textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.transparent),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {'flpiker': (context) => FlPiker(), 'load': (context) => Load()},
      home: Scaffold(
          // appBar: AppBar(
          //   title: Text('Material App Bar'),
          // ),
          drawer: new Drawer(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.access_alarm),
                  onTap: () {},
                  title: Text("Item 1"),
                ),
                ListTile(
                  leading: Icon(Icons.access_alarm),
                  onTap: () {},
                  title: Text("Item 2"),
                )
              ],
            ),
          ),
          body: SafeArea(child: HomePage())),
    );
  }
}
