import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ProductUpdate.dart';

class ViewProduct extends StatefulWidget {
  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("ViewProduct"),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Product").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.size <= 0) {
              return Center(
                child: Text("no data"),
              );
            } else {
              return ListView(
                children: snapshot.data.docs.map((documents) {
                  return Container(
                    color: Colors.blue.shade100,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height / 3.5,
                              child: Image.network(documents["imageurl"],width: 160.0,),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    documents["name"].toString().toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Quantity: " + documents["qty"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Rprice: " + documents["rprice"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Sprice: " + documents["sprice"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: ()async{
                                var docid = documents.id.toString();

                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>ProductUpdate(docid: docid,)
                                  ));
                              },
                              child: Text("Update"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                AlertDialog alert = AlertDialog(
                                  title: Text(
                                    "Warning",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25),
                                  ),
                                  content: Text("Are You Sure This Delete"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        var docid = documents.id.toString();

                                        await FirebaseStorage.instance.ref(documents["imagename"]).delete().then((value) async{
                                          await FirebaseFirestore.instance
                                              .collection("Product")
                                              .doc(docid)
                                              .delete()
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
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
                                  },
                                );
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
