import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/HomePage.dart';

class GoogleAuthentication extends StatefulWidget {

  @override
  State<GoogleAuthentication> createState() => _GoogleAuthenticationState();
}

class _GoogleAuthenticationState extends State<GoogleAuthentication> {

   FirebaseAuth _auth = FirebaseAuth.instance;
   GoogleSignIn _googleSignIn = GoogleSignIn();


   checklogin() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.containsKey("fullname"))
       {
         Navigator.of(context).pop();
         Navigator.of(context).push(
             MaterialPageRoute(builder: (context)=>HomePage())
         );
       }
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: ElevatedButton(
    onPressed: () async{

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      User _user = authResult.user;

      var name = _user.displayName.toString();
      var email = _user.email.toString();
      var photo = _user.photoURL.toString();
      var googleid = _user.uid.toString();

      // print("Name : "+name);
      // print("Email : "+email);
      // print("Photo : "+photo);
      // print("Google Id : "+googleid);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("fullname", name);
      prefs.setString("email", email);
      prefs.setString("photo", photo);
      prefs.setString("id", googleid);

      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>HomePage())
      );
    },
    child: Text("Login With Google"),
      ),
    ),
    );
  }
}
