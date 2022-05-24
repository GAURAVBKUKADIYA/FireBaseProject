
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FireBaseAddProduct extends StatefulWidget {


  @override
  State<FireBaseAddProduct> createState() => _FireBaseAddProductState();
}

class _FireBaseAddProductState extends State<FireBaseAddProduct> {
  TextEditingController _name = TextEditingController();
  TextEditingController _sallary = TextEditingController();
  TextEditingController _email =  TextEditingController();

  var _gender ="male";
  var _select = "Employed";

  File imagefile=null;
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("AddEmployed"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (imagefile!=null)?Image.file(imagefile,width: 300.0):Image.asset("img/img1.jpg"),
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


                        var uuid = Uuid();
                        var filename =uuid.v4().toString()+".jpg"; //110ec58a-a0f2-4ac4-8393-c866d813b8d1.jpg


                        await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata) async{
                            await filedata.ref.getDownloadURL().then((fileurl) async{
                              await FirebaseFirestore.instance.collection("Employee").add({
                                "name":name,
                                "salary":sallary,
                                "email":email,
                                "gender":gender,
                                "dept":select,
                                "imagename":filename,
                                "imageurl":fileurl
                              }).then((value){
                                _name.text="";
                                _sallary.text="";
                                _email.text="";
                                print("Record Inserted");
                              });
                            });
                        });







                      },

                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 50),
                        primary: Colors.green,),
                      child: Text("Add"),
                    ),


                    ElevatedButton(
                      onPressed: (){



                      },

                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(130, 40),
                        primary: Colors.red,),
                      child: Text("Cancle"),
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
