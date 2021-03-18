import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../firebase.dart';

final picker = ImagePicker();

Future getImage({BuildContext ctx, String animalId, String imageType}) async {
  final pickedFile = await picker.getImage(
    source: imageType == "camera" ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 50,
  );

  if (pickedFile != null) {
    Database.updateAnimalPhoto(animalId, File(pickedFile.path));
  } else {
    print('No image selected.');
  }
}
