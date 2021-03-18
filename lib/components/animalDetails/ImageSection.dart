import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_animals_manager/components/ModalOptions.dart';
import 'package:farm_animals_manager/components/chooseAnimalImage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ImageSection extends StatelessWidget {
  final QueryDocumentSnapshot animal;

  ImageSection({this.animal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 70,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: animal["imageUrl"],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: GestureDetector(
              onTap: () => showDialogBox(
                context,
                title: "Choose Image",
                subtitle: "Choose either one",
                dialogBoxActions: [
                  chooseAnimalsImage(ctx: context, animalId: animal.id)
                ],
                dismissOnClick: true,
              ),
              child: Container(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
