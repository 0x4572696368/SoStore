import 'package:app/pages/addProduct/AddProduct.dart';
import 'package:app/pages/homePage/components/body.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      // drawer: Drawer(
      //   elevation: 10000,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //           decoration: BoxDecoration(color: Colors.red),
      //           child: Column(
      //             children: [Expanded(child: Text("data"))],
      //           )),
      //       ListTile(
      //         leading: Icon(Icons.ac_unit),
      //         title: Text("Item 1"),
      //         onTap: () {},
      //       )
      //     ],
      //   ),
      // ),

      body: SafeArea(
        child: Body(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 100,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        color: Colors.black,
      ),
      actions: <Widget>[
        // IconButton(
        //     icon: Icon(
        //       Icons.search,
        //     ),
        //     color: Colors.black,
        //     onPressed: () {}),
        Badge(
          badgeColor: Colors.black12,
          position: BadgePosition.topEnd(top: 0, end: 0),
          badgeContent: Text(
            '9',
            style: TextStyle(color: Colors.white),
          ),
          animationType: BadgeAnimationType.scale,
          child: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Colors.black,
            onPressed: () {},
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          color: Colors.black,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
        ),
        SizedBox(
          width: 20 / 2,
        )
      ],
    );
  }
}
