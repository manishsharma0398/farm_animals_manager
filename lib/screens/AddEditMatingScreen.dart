import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

import '../firebase.dart';
import '../components/DateSelector.dart';

enum MatingType { animal, artificial }

class AddEditMatingScreen extends StatefulWidget {
  final String screenType;
  final String animalId;
  final QueryDocumentSnapshot mating;

  AddEditMatingScreen({
    @required this.screenType,
    this.mating,
    this.animalId,
  });

  @override
  _AddEditMatingScreenState createState() => _AddEditMatingScreenState();

  static _AddEditMatingScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_AddEditMatingScreenState>();
}

class _AddEditMatingScreenState extends State<AddEditMatingScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController animalBreedController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.screenType == "edit") {
      animalBreedController.text = widget.mating["breed"];
      remarksController.text = widget.mating["remarks"];

      _selectedMatingType = widget.mating["matingType"] == "natural"
          ? MatingType.animal
          : MatingType.artificial;

      final date = widget.mating["date"].toString().split("-");
      _matingDate = widget.mating["date"] == ""
          ? null
          : new DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
            );
    }
  }

  Widget buildFormFieldSeparator({double distance = 20}) {
    return SizedBox(
      height: distance,
    );
  }

  void submitForm() {
    print("form submitted successfully");

    if (_formKey.currentState.validate()) {
      Map<String, dynamic> matingDetails = {
        "matingType":
            _selectedMatingType == MatingType.animal ? "natural" : "artificial",
        "date": _matingDate.toString().split(" ")[0],
        "breed": animalBreedController.text,
        "remarks": remarksController.text,
      };

      if (widget.screenType == "add") {
        matingDetails.putIfAbsent("animalId", () => widget.animalId);
        Database.addMating(matingDetails);
      } else {
        Database.updateMating(widget.mating.id, matingDetails);
      }
    }
    Navigator.pop(context);
  }

  MatingType _selectedMatingType;
  DateTime _matingDate;

  Widget buildFormFieldTitle(String textToDisplay) {
    return Text(
      textToDisplay,
      style: Theme.of(context).textTheme.headline1,
    );
  }

  // Widget buildAnimalImage() {
  //   return Center(
  //     child: _image == null ? Text('No image selected.') : Image.file(_image),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: submitForm),
        ],
        title: Text(
          "Add Mating Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // animal status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // TODO: style it
                    buildFormFieldTitle("Mating Type"),
                    ListTile(
                      title: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMatingType = MatingType.animal;
                            });
                          },
                          child: Text('Breeder')),
                      leading: Radio(
                        value: MatingType.animal,
                        groupValue: _selectedMatingType,
                        onChanged: (MatingType value) {
                          setState(() {
                            _selectedMatingType = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMatingType = MatingType.artificial;
                            });
                          },
                          child: const Text('AI')),
                      leading: Radio(
                        value: MatingType.artificial,
                        groupValue: _selectedMatingType,
                        onChanged: (MatingType value) {
                          setState(() {
                            _selectedMatingType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                buildFormFieldSeparator(),
                // date of birth/purchased
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // buildFormFieldTitle(
                    //     '${_selectedAnimalStatus.index == 0 || _selectedAnimalStatus == null ? "Birth Date" : "Purchased Date"}'),
                    DateSelector(
                      value: "${_matingDate != null ? Jiffy([
                          _matingDate.toLocal().year,
                          _matingDate.toLocal().month,
                          _matingDate.toLocal().day
                        ]).format("MMMM do yyyy") : "Select date"}",
                      date: _matingDate,
                      callback: (val) => setState(() => _matingDate = val),
                    ),
                  ],
                ),
                // breed
                TextFormField(
                  controller: animalBreedController,
                  decoration: InputDecoration(labelText: "Breed"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                buildFormFieldSeparator(distance: 5),
                //  remarks
                TextFormField(
                  controller: remarksController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Remarks",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
