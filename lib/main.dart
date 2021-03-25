import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/personal_details.dart';
import 'package:resume/report_pdf.dart';
import 'package:resume/view/bottom_navigation.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: BottomNavigation(),
    );
  }
}

class PDFCreator extends StatefulWidget {
  @override
  _PDFCreatorState createState() => _PDFCreatorState();
}

class _PDFCreatorState extends State<PDFCreator> {
  final personalDetails= PersonalDetails(
    id: 1,
    name: "Pravin Gururani",
    jobTitle: "Senior Software Engineer",
    email: "pravingururani1997@gmail.com",
    phone: 8410230850,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              margin: EdgeInsets.only(top: 30),
              height: 40,
              child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Show Resume',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    DatabaseProvider.db.addUpdatePersonalDetails(personalDetails);
                    reportView(context);
                  }))),
    );
  }
}