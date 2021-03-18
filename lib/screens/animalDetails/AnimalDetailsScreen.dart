import 'package:farm_animals_manager/components/animalDetails/ImageSection.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/animalDetails/AnimalDetails.dart';
import '../../components/matingAndBreeding/MatingList.dart';
import '../../components/matingAndBreeding/BreedingList.dart';

import '../AddEditMatingScreen.dart';
import '../AddEditBreedingScreen.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot animal;

  AnimalDetailsScreen({@required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal['name']),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text(
              "Add More Details",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              // Image section
              ImageSection(animal: animal),
              // animal details
              AnimalDetails(animal: animal),
              SizedBox(height: 10),

              if (!animal["isCastrated"])
                InkWell(
                  onLongPress: () {
                    // TODO:: show form for new mating details
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => animal["gender"] == "male"
                            ? AddEditBreedingScreen()
                            : AddEditMatingScreen(
                                screenType: "add",
                                animalId: animal.id,
                              ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text(
                          "${animal["gender"] == "male" ? "Breeding" : "Mating"} History",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Hold to add new ${animal["gender"] == "male" ? "breeding" : "mating"} detail",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

              if (animal["gender"] == "female") MatingList(animal: animal),

              if (animal["gender"] == "male" && !animal["isCastrated"])
                BreedingList(animal: animal),

              if (animal["gender"] == "male" && animal["isCastrated"])
                Container(),
            ],
          ),
        ),
      ),
    );
  }
}
