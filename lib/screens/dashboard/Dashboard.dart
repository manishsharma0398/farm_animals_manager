import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../AddEditAnimals.dart';
import '../Castration.dart';
import 'DashboardItem.dart';

import '../../components/Drawer.dart';
import '../../components/ModalOptions.dart';

import '../../components/buildPopupMenuItem.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> addAnimalsDialogBoxActions(ctx) {
    return <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: MediaQuery.of(ctx).size.width,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (ctx) => AddEditAnimals(
                        screenType: "add",
                        animal: "cow",
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Image.asset("assets/images/cow.jpg"),
                    SizedBox(height: 10),
                    Text("Cow"),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (ctx) => AddEditAnimals(
                        screenType: "add",
                        animal: "goat",
                      ),
                    ),
                  );
                },
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/goat.jpg",
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10),
                      Text("Goat"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(ctx).pop();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          PopupMenuButton(
            onSelected: (result) {
              if (result == "castration") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CastrationFormScreen(),
                  ),
                );
              }

              if (result == "birth") {
                // Database.deleteAnimal(widget.animal.id);
              }
              if (result == "death") {
                // Database.deleteAnimal(widget.animal.id);
              }
              if (result == "sell") {
                // Database.deleteAnimal(widget.animal.id);
              }
            },
            icon: Icon(Icons.report),
            itemBuilder: (BuildContext context) => [
              buildPopupMenuItem(
                  menuIcon: Icons.power_off,
                  menuValue: "castration",
                  menuText: "Castration"),
              buildPopupMenuItem(
                  menuIcon: Icons.explore_off,
                  menuValue: "death",
                  menuText: "Death"),
              buildPopupMenuItem(
                  menuIcon: Icons.exit_to_app,
                  menuValue: "sell",
                  menuText: "Sell"),
              buildPopupMenuItem(
                  menuIcon: Icons.post_add,
                  menuValue: "birth",
                  menuText: "Birth"),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("animals").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Text("There is no data");
          } else {
            final List<QueryDocumentSnapshot> data = snapshot.data.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DashboardItem(
                  animal: data[index],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialogBox(context,
            title: 'Add an animal',
            subtitle: 'Select an animal to continue',
            dialogBoxActions: addAnimalsDialogBoxActions(context)),
      ),
    );
  }
}
