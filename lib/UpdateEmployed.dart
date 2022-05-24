

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateEmployed extends StatefulWidget {
  
  var docid="";
  UpdateEmployed({this.docid});


  @override
  State<UpdateEmployed> createState() => _UpdateEmployedState();
}

class _UpdateEmployedState extends State<UpdateEmployed> {

  TextEditingController _name = TextEditingController();
  TextEditingController _sallary = TextEditingController();
  TextEditingController _email =  TextEditingController();

  var _gender ="male";
  var _select = "Employed";

  File imagefile=null;
  ImagePicker _picker = ImagePicker();

  var oldimagename="";
  var oldimagefileurl="";

  getsingledata() async
  {
    await FirebaseFirestore.instance.collection("Employee").doc(widget.docid).get().then((document) async{
     setState(() {
       _name.text = document["name"].toString();
       _sallary.text = document["salary"].toString();
       _email.text = document["email"].toString();
       _gender = document["gender"].toString();
       _select = document["dept"].toString();
       oldimagename = document["imagename"].toString();
       oldimagefileurl = document["imageurl"].toString();
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
          child: Text("Update Employee"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (imagefile!=null)?Image.file(imagefile,width: 300.0):(oldimagefileurl!="")?Image.network(oldimagefileurl):Image.asset("img/img1.jpg"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      XFile photo = await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        imagefile = File(photo.path);
                      });
                    },
                    child: Text("Camera"),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      XFile photo = await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imagefile = File(photo.path);
                      });
                    },
                    child: Text("Gallary"),
                  ),
                ],
              ),

              Text("Name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              TextField(
                controller: _name,
                decoration:InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ) ,

                keyboardType: TextInputType.text,
              ),

              SizedBox(height: 10.0,),

              Text("Sallary",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              TextField(
                controller: _sallary,
                decoration:InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ) ,

                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0,),

              Text("EmailAddress",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              TextField(
                controller: _email,
                decoration:InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ) ,

                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gendre:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Radio(
                    groupValue: _gender,
                    value: "male",
                    onChanged: (val)
                    {
                      setState(() {
                        _gender=val;
                      });
                    },
                  ),
                  Text("Male",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  Radio(
                    groupValue: _gender,
                    value: "female",
                    onChanged: (val)
                    {
                      setState(() {
                        _gender=val;
                      });
                    },
                  ),
                  Text("Female",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                  Radio(
                    groupValue: _gender,
                    value: "other",
                    onChanged: (val)
                    {
                      setState(() {
                        _gender=val;
                      });
                    },
                  ),
                  Text("Other",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 10,),
              Row(

                children: [
                  Text("Department:",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  DropdownButton(
                    value: _select,
                    onChanged: (val)
                    {
                      setState(() {
                        _select=val;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text("Employed"),
                        value: "Employed",
                      ),
                      DropdownMenuItem(
                        child: Text("Marketing"),
                        value: "Marketing",
                      ),
                      DropdownMenuItem(
                        child: Text("Production"),
                        value: "Production",
                      ),
                      DropdownMenuItem(
                        child: Text("Staff"),
                        value: "Staff",
                      ),
                      DropdownMenuItem(
                        child: Text("Delivery"),
                        value: "Delivery",
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: ()  async{
                        var name = _name.text.toString();
                        var sallary = _sallary.text.toString();
                        var email = _email.text.toString();
                        var gender = _gender.toString();
                        var select = _select.toString();

                        if(imagefile!=null)
                          {
                            await FirebaseStorage.instance.ref(oldimagename).delete().then((value) async{
                              var uuid = Uuid();
                              var filename =uuid.v4().toString()+".jpg";
                              await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata) async{
                                await filedata.ref.getDownloadURL().then((fileurl) async{
                                  await FirebaseFirestore.instance.collection("Employee").doc(widget.docid).update({
                                    "name":name,
                                    "salary":sallary,
                                    "email":email,
                                    "gender":gender,
                                    "dept":select,
                                    "imagename":filename,
                                    "imageurl":fileurl
                                  }).then((value){
                                    Navigator.of(context).pop();
                                    print("Record updated");
                                  });
                                });
                              });
                            });
                          }
                        else
                          {
                            await FirebaseFirestore.instance.collection("Employee").doc(widget.docid).update({
                              "name":name,
                              "salary":sallary,
                              "email":email,
                              "gender":gender,
                              "dept":select,
                            }).then((value){
                              Navigator.of(context).pop();
                            });
                          }



                      },

                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,),
                      child: Text("Update"),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
