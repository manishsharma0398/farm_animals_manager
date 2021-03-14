import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

import '../../firebase.dart';
import '../NoRecordFound.dart';
import '../../screens/AddEditMatingScreen.dart';

class BreedingList extends StatelessWidget {
  final QueryDocumentSnapshot animal;

  BreedingList({@required this.animal});

  String expectedDeliveryDate(String matingDate) {
    var date1 = DateTime.parse("$matingDate");

    var minDate =
        date1.add(Duration(days: animal['animal'] == "goat" ? 145 : 279));

    var maxDate =
        date1.add(Duration(days: animal['animal'] == "goat" ? 152 : 287));

    print(minDate);
    print(maxDate);

    String deliveryDate = "";

    if (minDate.month == maxDate.month) {
      deliveryDate +=
          "${minDate.day} to ${maxDate.day} ${Jiffy(minDate).MMMM} ${minDate.year}";
    } else if (minDate.month != maxDate.month && minDate.year == maxDate.year) {
      deliveryDate += "${minDate.day} ${Jiffy(minDate).MMMM} to ${maxDate.day}"
          " ${Jiffy(maxDate).MMMM} ${minDate.year}";
    } else {
      deliveryDate +=
          "${minDate.day} ${Jiffy(minDate).MMMM} ${minDate.year} to ${maxDate.day} ${Jiffy(maxDate).MMMM} ${maxDate.year}";
    }

    return deliveryDate;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("mating")
          .where("animalId", isEqualTo: animal.id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List<QueryDocumentSnapshot> data = snapshot.data.docs;

          List<Widget> widgets = new List<Widget>();

          for (var i = 0; i < data.length; i++) {
            QueryDocumentSnapshot matingDetail = data[i];
            final List<String> matingDate =
                matingDetail['date'].toString().split("-");

            int year = int.parse(matingDate[0]);
            int month = int.parse(matingDate[1]);
            int date = int.parse(matingDate[2]);

            widgets.add(
              new Container(
                width: MediaQuery.of(context).size.width,
                // padding: const EdgeInsets.symmetric(vertical: 15),
                // child: DashboardItem(
                //   animal: data[index],
                // ),
                child: Card(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mating Type: ${matingDetail["matingType"] == "artificial" ? "AI" : "Breeder"}',
                          ),
                          Text('Breed Used: ${matingDetail['breed']}'),
                          Text('Mating Date: ${Jiffy([
                            year,
                            month,
                            date
                          ]).format("do MMMM yyyy")}'),
                          Text("Delivery within: " +
                              expectedDeliveryDate(matingDetail['date'])),
                        ],
                      ),
                      Expanded(
                        child: PopupMenuButton(
                          onSelected: (result) {
                            if (result == "edit") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddEditMatingScreen(
                                    screenType: "edit",
                                    mating: data[i],
                                  ),
                                ),
                              );
                            }

                            if (result == "delete") {
                              Database.deleteMating(data[i].id);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 10),
                                  Text("Update"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          if (data.length > 0) {
            return new Column(children: widgets);
          } else {
            return NoRecord();
          }
        }

        if (!snapshot.hasData) NoRecord();

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
