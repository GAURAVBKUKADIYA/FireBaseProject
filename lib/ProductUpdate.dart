

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductUpdate extends StatefulWidget {

  var docid="";
  ProductUpdate({this.docid});


  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {

  TextEditingController _name = TextEditingController();
  TextEditingController _qty = TextEditingController();
  TextEditingController _rprice = TextEditingController();
  TextEditingController _sprice = TextEditingController();

  File imagefile=null;
  ImagePicker _picker = ImagePicker();

  var oldimagename="";
  var oldimagefileurl="";

  getsingledata()async
  {
    await FirebaseFirestore.instance.collection("Product").doc(widget.docid).get().then((documents)async{
     setState(() {
       _name.text = documents["name"].toString();
       _qty.text = documents["qty"].toString();
       _rprice.text = documents["rprice"].toString();
       _sprice.text = documents["sprice"].toString();
       oldimagename = documents["imagename"].toString();
       oldimagefileurl = documents["imageurl"].toString();

     });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsingledata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("UpdateProduct"),
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
                child:  (imagefile!=null)?Image.file(imagefile,height: 300.0,):(oldimagefileurl!="")? Image.network(oldimagefileurl,height: 300.0,):Image.asset("appphoto1.jpg"),

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


                    if(imagefile!=null)
                      {
                        await FirebaseStorage.instance.ref(oldimagename).delete().then((value) async {
                          var uuid = Uuid();
                          var filename = uuid .v4().toString()+".jpg";

                          await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata)async{
                            await filedata.ref.getDownloadURL().then((fileurl)async{

                              await FirebaseFirestore.instance.collection("Product").doc(widget.docid).update({
                                "name": name,
                                "qty": qty,
                                "rprice": rprice,
                                "sprice": sprice,
                                "imagename":filename,
                                "imageurl":fileurl
                              }).then((value) {
                                Navigator.of(context).pop();
                                _name.text="";
                                _qty.text="";
                                _rprice.text="";
                                _sprice.text="";

                              });

                            });
                          });

                        });
                      }
                    else
                      {
                        await FirebaseFirestore.instance.collection("Product").doc(widget.docid).update({
                          "name": name,
                          "qty": qty,
                          "rprice": rprice,
                          "sprice": sprice,
                        }).then((value)  {
                          Navigator.of(context).pop();
                        });
                      }



                  },


                  child: Text(
                    "Update",
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
