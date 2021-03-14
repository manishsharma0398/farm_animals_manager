// import 'dart:convert';

// Animal animalFromJson(String str) {
//   final jsonData = json.decode(str);
//   return Animal.fromMap(jsonData);
// }

// String animalToJson(Animal data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }

class Animal {
  int id;
  String animal;
  String status;
  String name;
  String date;
  String gender;
  String breed;
  String remarks;
  String imageUrl;

  Animal({
    this.id,
    this.animal,
    this.status,
    this.name,
    this.date,
    this.gender,
    this.breed,
    this.remarks,
    this.imageUrl,
  });

  // factory Animal.fromMap(Map<String, dynamic> json) => new Animal(
  //       id: json["id"],
  //       animal: json["animal"],
  //       status: json["status"],
  //       name: json["name"],
  //       date: json["date"],
  //       gender: json["gender"],
  //       breed: json["breed"],
  //       remarks: json["remarks"],
  //       imageUrl: json["imageUrl"],
  //     );

  // Map<String, dynamic> toMap() => {
  //       "id": id,
  //       "animal": animal,
  //       "status": status,
  //       "name": name,
  //       "date": date,
  //       "gender": gender,
  //       "breed": breed,
  //       "remarks": remarks,
  //       "imageUrl": imageUrl,
  //     };
}
