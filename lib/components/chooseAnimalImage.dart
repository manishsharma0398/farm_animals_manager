import 'package:farm_animals_manager/components/pickImage.dart';
import 'package:flutter/material.dart';

Widget chooseAnimalsImage({BuildContext ctx, String animalId}) {
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
                    onPressed: () =>
                        selectImageLocation("camera", animalId, ctx),
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
                    onPressed: () =>
                        selectImageLocation("gallery", animalId, ctx),
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

selectImageLocation(String imageLocation, String animalId, BuildContext con) {
  getImage(
    imageType: imageLocation,
    animalId: animalId,
  );

  return Navigator.pop(con);
}
