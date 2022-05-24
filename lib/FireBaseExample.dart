import 'package:flutter/material.dart';
import 'package:untitled/AddStudent.dart';
import 'package:untitled/FireBaseAddEmployed.dart';

import 'AddProduct.dart';
import 'FireBaseViewEmployed.dart';
import 'GoogleAuthentication.dart';
import 'ViewProduct.dart';
import 'ViewStudent.dart';

class FireBaseExample extends StatefulWidget {


  @override
  State<FireBaseExample> createState() => _FireBaseExampleState();
}

class _FireBaseExampleState extends State<FireBaseExample> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("FireBase"),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Text("G"),
              ),
              accountName: Text("Welcome,Product Sheet"),
              accountEmail: Text("Welcome Employed Sheet"),
            ),
            Divider(height: 5,),
            ListTile(
              title: Text("AddProduct"),
              trailing: Icon(Icons.arrow_right_alt),

              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>AddProduct())
                );
              },
            ),
            Divider(height: 5,),
            ListTile(

              title: Text("ViewProduct"),
              trailing: Icon(Icons.arrow_right_alt),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>ViewProduct()));
              },
            ),
            Divider(height: 5,),
            ListTile(
              title: Text("AddEmployed"),
              trailing: Icon(Icons.arrow_right_alt),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>FireBaseAddProduct())
                );
              },

            ),
            Divider(height: 5,),
            ListTile(
              title: Text("ViewEmployed"),
              trailing: Icon(Icons.arrow_right_alt),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>FireBaseViewEmployed())
                );
              },
            ),
            Divider(height: 5,),
            ListTile(
              title: Text("AddStudent"),
              trailing: Icon(Icons.arrow_right_alt),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>AddStudent())
                );
              },
            ),
            Divider(height: 5,),
            ListTile(
              title: Text("View Student"),
              trailing: Icon(Icons.arrow_right_alt),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>ViewStudent())
                );
              },
            ),

            Divider(height: 15,),


            Divider(height: 5,),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_right_alt),
            ),
            Divider(height: 15,),


            Divider(height: 5,),
            ListTile(
              title: Text("GoogleAuthentication"),
              trailing: Icon(Icons.arrow_right_alt),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>GoogleAuthentication())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
