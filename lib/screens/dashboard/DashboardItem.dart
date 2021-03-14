import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase.dart';

import '../../components/ModalOptions.dart';
import '../AddEditAnimals.dart';
import '../AnimalDetailsScreen.dart';
import './DashboardItemActions.dart';

class DashboardItem extends StatefulWidget {
  final QueryDocumentSnapshot animal;

  DashboardItem({@required this.animal});

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  final picker = ImagePicker();

  DashboardItemActions selectedActions;

  Future getImage({BuildContext cont, String imageType}) async {
    final pickedFile = await picker.getImage(
      source: imageType == "camera" ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      Database.updateAnimalPhoto(widget.animal.id, File(pickedFile.path));
    } else {
      print('No image selected.');
    }

    Navigator.pop(cont);
  }

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
            // style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          // Text(
          //   '$viewCount views',
          //   style: const TextStyle(fontSize: 10.0),
          // ),
        ],
      ),
    );
  }

  Widget chooseAnimalsImage(ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () => getImage(
                        imageType: "camera",
                        cont: ctx,
                      ),
                    ),
                    Text("Camera")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () => getImage(
                        imageType: "gallery",
                        cont: ctx,
                      ),
                    ),
                    Text("Gallery")
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
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
                GestureDetector(
                  onLongPress: () => showDialogBox(
                    context,
                    title: "Choose Image",
                    subtitle: "Choose either one",
                    dialogBoxActions: [chooseAnimalsImage(context)],
                    dismissOnClick: true,
                  ),
                  child: CachedNetworkImage(
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
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 10),
                          Text("Update"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 10),
                          Text("Delete"),
                        ],
                      ),
                    ),
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
