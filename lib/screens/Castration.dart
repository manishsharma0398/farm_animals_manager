import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

import '../firebase.dart';

import '../components/FormField.dart';
import '../components/DateSelector.dart';

class CastrationFormScreen extends StatefulWidget {
  @override
  _CastrationFormScreenState createState() => _CastrationFormScreenState();

  static _CastrationFormScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_CastrationFormScreenState>();
}

class _CastrationFormScreenState extends State<CastrationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController animalBreedController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  DateTime _castrationDate;
  String _selectedAnimal;

  List<Map<String, dynamic>> maleAnimals = [];

  @override
  void initState() {
    super.initState();
    _getMaleAnimals();
  }

  _getMaleAnimals() async {
    QuerySnapshot data = await Database.getNotCastratedMaleAnimals();

    List<QueryDocumentSnapshot> docs = data.docs;
    List<Map<String, dynamic>> animals = [];

    for (var doc in docs) {
      animals.add({
        "id": doc.id,
        "imageUrl": doc["imageUrl"],
        "name": doc["name"],
      });
    }

    setState(() {
      maleAnimals = animals;
    });
  }

  Widget buildDropdownWithImage() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isDense: true,
                hint: Text("Select animal"),
                value: _selectedAnimal,
                onChanged: (String newVal) {
                  setState(() {
                    _selectedAnimal = newVal;
                  });
                  print(newVal);
                },
                items: maleAnimals.map((Map animals) {
                  return DropdownMenuItem<String>(
                    value: animals["id"].toString(),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: animals['imageUrl'] != ""
                              ? animals["imageUrl"]
                              : animals["animal"] == "cow"
                                  ? "https://easydrawingguides.com/wp-content/uploads/2017/03/How-to-draw-a-cartoon-cow-20.png"
                                  : "https://i.pinimg.com/originals/60/ea/69/60ea69d49e0e706940e283d83fcd709b.jpg",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 60,
                          // fit: BoxFit.cover,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(animals['name']),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Castration Form"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Database.updateAnimal(
                _selectedAnimal,
                {"isCastrated": true, "castratedDate": _castrationDate},
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Field(
                fieldLabel: "Select Animal",
                field: buildDropdownWithImage(),
              ),
              DateSelector(
                callback: (val) => setState(() => _castrationDate = val),
                date: _castrationDate,
                value: _castrationDate == null
                    ? 'Select Castration Date'
                    : Jiffy(_castrationDate).format("do MMMM yyyy"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
