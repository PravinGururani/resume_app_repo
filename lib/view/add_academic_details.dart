import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/misc/my_text_field_date_picker.dart';
import 'package:resume/model/academic_details.dart';
import 'package:resume/view/reusable_widgets.dart';

import 'colors/colors.dart';
class AddAcademicDetails extends StatefulWidget {
  @override
  _AddAcademicDetailsState createState() => _AddAcademicDetailsState();

  AddAcademicDetails({@required this.resumeId});
  final int resumeId;
}

class _AddAcademicDetailsState extends State<AddAcademicDetails> {
  final formKey = new GlobalKey<FormState>();
  List<AcademicDetails> listAcademicDetails=[];

  addToList(AcademicDetails academicDetails) async{
    academicDetails.resumeId=widget.resumeId;
    print("TEST:${widget.resumeId}");
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await DatabaseProvider.db.addUpdateAcademicDetails(academicDetails);
      listAcademicDetails.clear();
      setState(() {
      });
      Navigator.pop(context);
    }
  }

  Future <List<AcademicDetails>> getAllAcademicDetails() async{
    await DatabaseProvider.db.getAllAcademicDetails(widget.resumeId).then((value) {
      listAcademicDetails=value;
    });
    return listAcademicDetails;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllAcademicDetails(),
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: FloatingActionButton(
                  backgroundColor: fab,
                  child: Icon(Icons.add, size: 40,),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: bottomSheet(new AcademicDetails()),
                        );
                      },
                    );
                  },
                ),
              ),
              body: ListView(
                children: List.generate(snapshot.data.length, (index){
                  return Dismissible(
                    key: Key(snapshot.data[index].id.toString()),
                    background: ReusableWidgets.editBackground,
                    secondaryBackground: ReusableWidgets.deleteBackground,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        final bool res = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    "Are you sure you want to delete?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        DatabaseProvider.db.deleteAcademicDetailsById(snapshot.data[index].id);

                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            });
                        return res;
                      } else {
                        return true;
                      }
                    },
                    onDismissed: (direction){
                      showModalBottomSheet<void>(
                        isDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return bottomSheet(snapshot.data[index]);
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("${snapshot.data[index].course}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),],),
                                    Row(
                                      children: [
                                        Text("${snapshot.data[index].university}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text("${snapshot.data[index].yearOfPassing}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text("${snapshot.data[index].percentage}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  // return Text("${listAcademicDetails[index].companyName}",
                  // style: TextStyle(color: Colors.black),);
                },
                ),
              ),
              /*bottomNavigationBar: GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddAcademicDetailsDialogue();
                },
              );
            },
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('NEXT >>>>',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),*/
            ),
          );
        }
        else{
          return Container();
        }
      },
    );
  }

  Widget bottomSheet(AcademicDetails academicDetails){
    return Form(
      key: formKey,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Course';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  onSaved: (value){
                    academicDetails.course=value;
                  },
                  enabled: true,
                  initialValue: academicDetails.course,
                  decoration: InputDecoration(
                      labelText: 'Course Name',
                      //border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  initialValue: academicDetails.university,
                  onSaved: (value){
                    academicDetails.university=value;
                  },
                  enabled: true,
                  //initialValue: widget.service,
                  decoration: InputDecoration(
                      labelText: 'University',
                      //border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  initialValue: academicDetails == null ||
                      academicDetails.yearOfPassing == null ? "" : academicDetails.yearOfPassing.toString(),
                  onSaved: (value){
                    academicDetails.yearOfPassing=int.parse(value);
                  },
                  enabled: true,
                  //initialValue: widget.service,
                  decoration: InputDecoration(
                      labelText: 'Year of Passing',
                      //border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  initialValue: academicDetails == null ||
                      academicDetails.percentage == null ? "" : academicDetails.percentage.toString(),
                  onSaved: (value){
                    academicDetails.percentage=double.parse(value);
                  },
                  enabled: true,
                  //initialValue: widget.service,
                  decoration: InputDecoration(
                      labelText: 'Percentage',
                      //border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.green;
                            return save_cancel; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.green;
                            return save_cancel; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        addToList(academicDetails);
                      },
                      child: Text("Save"),
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

