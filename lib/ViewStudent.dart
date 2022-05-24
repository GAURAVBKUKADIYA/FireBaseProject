import 'package:flutter/material.dart';

class ViewStudent extends StatefulWidget {


  @override
  State<ViewStudent> createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ViewStudent"),
      ),
    );
  }
}
