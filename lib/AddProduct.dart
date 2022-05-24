import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _name = TextEditingController();
  TextEditingController _qty = TextEditingController();
  TextEditingController _rprice = TextEditingController();
  TextEditingController _sprice = TextEditingController();

  File imagefile=null;
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("AddProduct"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Container(
               color: Colors.red.shade50,
               width: MediaQuery.of(context).size.width,
               child:  (imagefile!=null)?Image.file(imagefile,height: 300.0,): Image.asset("img/img2.webp",height: 300.0,),

             ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: ()async{
                      XFile photo = await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        imagefile = File(photo.path);
                      });
                    },

                    child: Text("Camera"),
                  ),
                  ElevatedButton(
                    onPressed: ()async{
                      XFile photo = await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imagefile = File(photo.path);
                      });
                    },

                    child: Text("Gallery"),
                  ),
                ],
              ),

              Text(
                "Name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                    hintText: ("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Quantity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _qty,
                decoration: InputDecoration(
                    hintText: ("Quantity"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "RegularPrice:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _rprice,
                decoration: InputDecoration(
                    hintText: ("RegularPrice"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "SellPrice",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _sprice,
                decoration: InputDecoration(
                    hintText: ("SellPrice"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var name = _name.text.toString();
                    var qty = _qty.text.toString();
                    var rprice = _rprice.text.toString();
                    var sprice = _sprice.text.toString();


                    if(name.length<=0)
                      {
                        Fluttertoast.showToast(
                                msg: "Please Add Product Name",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue.shade400,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                        }
                        else if(qty.length<=0)
                          {
                            Fluttertoast.showToast(
                                msg: "Add Quantity",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue.shade400,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                    else if(rprice.length<=0)
                    {
                      Fluttertoast.showToast(
                          msg: "Select Reguler Price",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else if(sprice.length<=0)
                    {
                      Fluttertoast.showToast(
                          msg: "Select Final  Price",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else{

                      var uuid = Uuid();
                      var filename = uuid .v4().toString()+".jpg";

                      await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata)async{
                        await filedata.ref.getDownloadURL().then((fileurl)async{

                          await FirebaseFirestore.instance.collection("Product").add({
                            "name": name,
                            "qty": qty,
                            "rprice": rprice,
                            "sprice": sprice,
                            "imagename":filename,
                            "imageurl":fileurl
                          }).then((value) {
                            _name.text="";
                            _qty.text="";
                            _rprice.text="";
                            _sprice.text="";

                          });

                        });
                      });


                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
