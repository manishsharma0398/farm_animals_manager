import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

import '../firebase.dart';

import 'dashboard/Dashboard.dart';
import '../components/DateSelector.dart';

enum AnimalStatus { bornOnForm, purchased }
enum AnimalGender { male, female, castrated }

class AddEditAnimals extends StatefulWidget {
  final String screenType;
  final String animal;
  final QueryDocumentSnapshot animalDetails;

  const AddEditAnimals({
    @required this.screenType,
    @required this.animal,
    this.animalDetails,
  });

  @override
  _AddEditAnimalsState createState() => _AddEditAnimalsState();

  static _AddEditAnimalsState of(BuildContext context) =>
      context.findAncestorStateOfType<_AddEditAnimalsState>();
}

class _AddEditAnimalsState extends State<AddEditAnimals> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController animalNameController = TextEditingController();
  TextEditingController animalBreedController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    List<String> date;

    super.initState();
    print(widget.screenType);
    if (widget.screenType == "edit") {
      animalNameController.text = widget.animalDetails["name"];
      animalBreedController.text = widget.animalDetails["breed"];
      remarksController.text = widget.animalDetails["remarks"];

      _selectedAnimalStatus = widget.animalDetails["status"] == "purchased"
          ? AnimalStatus.purchased
          : AnimalStatus.bornOnForm;
      _selectedAnimalGender = widget.animalDetails["gender"] == "male"
          ? AnimalGender.male
          : widget.animalDetails["gender"] == "female"
              ? AnimalGender.female
              : AnimalGender.castrated;
      date = widget.animalDetails["date"].toString().split("-");
      _selectedDate = widget.animalDetails["date"] == ""
          ? null
          : DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
            );
    }
    // print(DateTime(widget.animalDetails["date"]));
  }

  Widget buildFormFieldSeparator({double distance = 20}) {
    return SizedBox(
      height: distance,
    );
  }

  void submitForm() {
    print("form submitted successfully");

    if (_formKey.currentState.validate()) {
      Map<String, dynamic> animalDetails = {
        "animal": widget.animal,
        "status": _selectedAnimalStatus.index == 0 ? "bornOnFarm" : "purchased",
        "name": animalNameController.text,
        "date":
            _selectedDate != null ? _selectedDate.toString().split(" ")[0] : "",
        "gender": _selectedAnimalGender.index == 0
            ? "male"
            : _selectedAnimalGender.index == 1
                ? "female"
                : "castrated",
        "breed": animalBreedController.text,
        "remarks": remarksController.text,
      };

      if (widget.screenType == "add") {
        animalDetails.putIfAbsent("imageUrl", () => "");
        Database.addAnimal(animalDetails);
      } else {
        Database.updateAnimal(widget.animalDetails.id, animalDetails);
      }
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false);
  }

  AnimalStatus _selectedAnimalStatus = AnimalStatus.bornOnForm;
  AnimalGender _selectedAnimalGender;
  DateTime _selectedDate;

  Widget buildFormFieldTitle(String textToDisplay) {
    return Text(
      textToDisplay,
      style: Theme.of(context).textTheme.headline1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: submitForm),
        ],
        title: Text(
          "${widget.screenType == "add" ? "Add New" : "Edit"} ${widget.animal == "cow" ? "Cow" : "Goat"}",
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
                    buildFormFieldTitle("Animal Status"),
                    ListTile(
                      title: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedAnimalStatus = AnimalStatus.bornOnForm;
                            });
                          },
                          child: const Text('Born On Farm')),
                      leading: Radio(
                        value: AnimalStatus.bornOnForm,
                        groupValue: _selectedAnimalStatus,
                        onChanged: (AnimalStatus value) {
                          setState(() {
                            _selectedAnimalStatus = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedAnimalStatus = AnimalStatus.purchased;
                            });
                          },
                          child: const Text('Purchased')),
                      leading: Radio(
                        value: AnimalStatus.purchased,
                        groupValue: _selectedAnimalStatus,
                        onChanged: (AnimalStatus value) {
                          setState(() {
                            _selectedAnimalStatus = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // animal identifier/name
                TextFormField(
                  controller: animalNameController,
                  decoration: InputDecoration(labelText: "Name/Identifier"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                buildFormFieldSeparator(),
                // date of birth/purchased
                DateSelector(
                  callback: (val) => setState(() => _selectedDate = val),
                  date: _selectedDate,
                  value: _selectedDate != null ||
                          widget.screenType == "edit" &&
                              widget.animalDetails['date'].toString().length > 0
                      ? Jiffy([
                          (_selectedDate.toLocal().year),
                          (_selectedDate.toLocal().month),
                          (_selectedDate.toLocal().day)
                        ]).format("MMMM do yyyy")
                      : "Select Date",
                ),
                buildFormFieldSeparator(distance: 10.toDouble()),
                // gender
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // TODO: style it
                    buildFormFieldTitle("Gender"),
                    ListTile(
                      title: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedAnimalGender = AnimalGender.male;
                            });
                          },
                          child: const Text('Male')),
                      leading: Radio(
                        value: AnimalGender.male,
                        groupValue: _selectedAnimalGender,
                        onChanged: (AnimalGender value) {
                          setState(() {
                            _selectedAnimalGender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedAnimalGender = AnimalGender.female;
                            });
                          },
                          child: const Text('Female')),
                      leading: Radio(
                        value: AnimalGender.female,
                        groupValue: _selectedAnimalGender,
                        onChanged: (AnimalGender value) {
                          setState(() {
                            _selectedAnimalGender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAnimalGender = AnimalGender.castrated;
                          });
                        },
                        child: Text(
                            "Castrated / ${widget.animal == 'goat' ? 'Khasi' : ''}"),
                      ),
                      leading: Radio(
                        value: AnimalGender.castrated,
                        groupValue: _selectedAnimalGender,
                        onChanged: (AnimalGender value) {
                          setState(() {
                            _selectedAnimalGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                buildFormFieldSeparator(distance: 0),
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
