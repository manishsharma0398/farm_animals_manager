import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference animalsCollection = _db.collection("animals");

  static Future<void> addAnimal(Map<String, dynamic> animal) async {
    await _db.collection('animals').add(animal).then((value) => print(value));
  }

  static Future<void> addMating(Map<String, dynamic> matingDetails) async {
    await _db
        .collection('mating')
        .add(matingDetails)
        .then((value) => print(value));
  }

  static Future<QuerySnapshot> getNotCastratedMaleAnimals() async {
    return await _db
        .collection('animals')
        .where("gender", isEqualTo: "male")
        .where("isCastrated", isEqualTo: false)
        .get();
  }

  static Future<void> updateAnimal(
      String animalId, Map<String, dynamic> animal) async {
    await _db.collection('animals').doc(animalId).update(animal);
  }

  static Future<void> updateMating(
      String matingId, Map<String, dynamic> mating) async {
    await _db.collection('mating').doc(matingId).update(mating);
  }

  static Future<void> updateAnimalPhoto(String animalId, File image) async {
    String fileNameExtension = basename(image.path).split(".")[1];
    // print(fileName);

    FirebaseStorage _storage = FirebaseStorage.instance;

    Reference reference =
        _storage.ref().child("animals/$animalId.$fileNameExtension");

    await reference.putFile(image);

    var imageUrl = await reference.getDownloadURL();

    await updateAnimal(animalId, {"imageUrl": imageUrl.toString()});
  }

  static Future<void> deleteAnimal(String animalId) async {
    await _db.collection("animals").doc(animalId).delete();
  }

  static Future<void> deleteMating(String matingId) async {
    await _db.collection('mating').doc(matingId).delete();
  }
}
