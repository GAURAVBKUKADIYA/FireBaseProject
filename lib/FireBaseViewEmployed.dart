import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'UpdateEmployed.dart';

class FireBaseViewEmployed extends StatefulWidget {
  @override
  State<FireBaseViewEmployed> createState() => _FireBaseViewEmployedState();
}

class _FireBaseViewEmployedState extends State<FireBaseViewEmployed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("ViewEmployed"),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Employee").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.size <= 0) {
              return Center(child: Text("No Data"));
            } else {
              return ListView(
                children: snapshot.data.docs.map((document) {
                  return Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.blue.shade50,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(document["imageurl"]),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: " +
                                  document["name"].toString().toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Divider(
                              height: 5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Sallary: " + document["salary"]),
                            Divider(
                              height: 5,
                            ),
                            Text("Email: " + document["email"]),
                            Divider(
                              height: 5,
                            ),
                            Text("Gender: " + document["gender"]),
                            Divider(
                              height: 5,
                            ),
                            Text("Department: " + document["dept"]),
                            Divider(
                              height: 5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                var docid = document.id.toString();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> UpdateEmployed(docid: docid,))
                                );
                              },
                              child: Text("Update"),
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                AlertDialog alert = AlertDialog(
                                  title: Text(
                                    "Warning",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text("Are You Sure This Delete"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        var docid = document.id.toString();

                                        await FirebaseStorage.instance
                                            .ref(document["imagename"])
                                            .delete()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection("Employee")
                                              .doc(docid)
                                              .delete()
                                              .then((value) {
                                            print("Record Deleted");
                                          });
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("Yes"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("No"),
                                    ),
                                  ],
                                );
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    });
                              },
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
