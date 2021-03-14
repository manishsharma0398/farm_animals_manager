import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Manish Sharma"),
            accountEmail: Text("man06101999@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "M",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Animals"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) => Animals()),
              // );
            },
          ),
          ListTile(
            title: Text("Item 2"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (BuildContext context) => NewPage("Page two")),
              // );
            },
          ),
        ],
      ),
    );
  }
}
