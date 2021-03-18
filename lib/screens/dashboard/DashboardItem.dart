import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase.dart';
import '../AddEditAnimals.dart';
import '../animalDetails/AnimalDetailsScreen.dart';

import '../../components/buildPopupMenuItem.dart';

class DashboardItem extends StatefulWidget {
  final QueryDocumentSnapshot animal;

  DashboardItem({@required this.animal});

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  Widget buildAnimalDescription({String title, String subTitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            subTitle,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnimalDetailsScreen(animal: widget.animal),
            ),
          );
        },
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.animal['imageUrl'] != ""
                      ? widget.animal["imageUrl"]
                      : widget.animal["animal"] == "cow"
                          ? "https://easydrawingguides.com/wp-content/uploads/2017/03/How-to-draw-a-cartoon-cow-20.png"
                          : "https://i.pinimg.com/originals/60/ea/69/60ea69d49e0e706940e283d83fcd709b.jpg",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 180,
                  height: 180,
                  // fit: BoxFit.cover,
                ),
                Expanded(
                  // flex: 3,
                  child: buildAnimalDescription(
                    title: widget.animal["name"],
                    subTitle: widget.animal["animal"],
                  ),
                ),
                PopupMenuButton(
                  onSelected: (result) {
                    if (result == "edit") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddEditAnimals(
                            screenType: "edit",
                            animal: widget.animal["animal"],
                            animalDetails: widget.animal,
                          ),
                        ),
                      );
                    }

                    if (result == "delete") {
                      Database.deleteAnimal(widget.animal.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    buildPopupMenuItem(
                        menuIcon: Icons.edit,
                        menuText: "Update",
                        menuValue: "edit"),
                    buildPopupMenuItem(
                        menuIcon: Icons.delete,
                        menuText: "Delete",
                        menuValue: "delete"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
