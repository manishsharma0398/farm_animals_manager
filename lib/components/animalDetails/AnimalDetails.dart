import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

class AnimalDetails extends StatelessWidget {
  final QueryDocumentSnapshot animal;

  AnimalDetails({@required this.animal});

  Widget _buildChips({String key, String val, String extraData}) {
    return Row(
      children: [
        Text("$key "),
        SizedBox(width: 10),
        Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(
            val,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        SizedBox(
          height: 40,
          width: 10,
        ),
        if (extraData != null)
          Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(
              extraData,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        _buildChips(
          key: "Name",
          val: animal["name"],
        ),
        _buildChips(
          key: "Breed",
          val: animal["breed"],
        ),
        _buildChips(
          key: "Status",
          val: animal["status"] == "bornOnFarm" ? "Born On Farm" : "Purchased",
        ),
        _buildChips(
          key: animal["status"] == "bornOnFarm"
              ? "Date Of Birth"
              : "Purchased Date",
          val: animal['date'] == ""
              ? "Not Added"
              : Jiffy(animal["date"]).format("do MMMM yyyy"),
        ),
        _buildChips(
          key: "Gender",
          val: animal['gender'] == 'female' ? 'Female' : 'Male',
          extraData: animal['isCastrated']
              ? animal['animal'] == 'goat'
                  ? 'Khasi/Castrated'
                  : 'Bull/Saand'
              : null,
        ),
        _buildChips(
          key: "Remarks",
          val: animal["remarks"],
        ),
      ],
    );
  }
}
