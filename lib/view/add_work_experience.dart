import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/misc/my_text_field_date_picker.dart';
import 'package:resume/model/work_experience.dart';
import 'package:resume/view/add_work_experience_dialogue.dart';
import 'package:intl/intl.dart';
import 'package:resume/view/reusable_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors/colors.dart';
import 'package:date_time_picker/date_time_picker.dart';


class AddWorkExperience extends StatefulWidget {
  @override
  _AddWorkExperienceState createState() => _AddWorkExperienceState();

  AddWorkExperience({@required this.resumeId});
  final int resumeId;
}



class _AddWorkExperienceState extends State<AddWorkExperience> {

  final formKey = new GlobalKey<FormState>();
  List<WorkExperience> listWorkExperience=[];

  addToList(WorkExperience workExperience) async{
    print('DATE TEST ${workExperience.startDate}');
    print('DATE TEST ${workExperience.endDate}');
    workExperience.resumeId=widget.resumeId;
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await DatabaseProvider.db.addUpdateWorkExperience(workExperience);
      listWorkExperience.clear();
      setState(() {
      });
      Navigator.pop(context);
    }
  }

  Future <List<WorkExperience>> getAllWorkExperience() async{
    await DatabaseProvider.db.getAllWorkExperience(widget.resumeId).then((value) {
      listWorkExperience=value;
    });
    if(listWorkExperience.isNotEmpty){
      print(listWorkExperience.first.startDate);
    }
    return listWorkExperience;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllWorkExperience(),
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
                      builder: (BuildContext context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: bottomSheet(new WorkExperience()),
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
                                        DatabaseProvider.db.deleteWorkExperienceById(snapshot.data[index].id);
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
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: bottomSheet(snapshot.data[index]),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Text("${snapshot.data[index].companyName}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                        ),
                                        snapshot.data[index].startDate==null || snapshot.data[index].endDate==null
                                            ?
                                        Container()
                                            :
                                        Row(
                                          children: [
                                            Text("${snapshot.data[index].startDate.substring(0,4)} - ${snapshot.data[index].endDate.substring(0,4)}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("${snapshot.data[index].jobTitle}",
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
                                          child: Text("${snapshot.data[index].details}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
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
                  // return Text("${listWorkExperience[index].companyName}",
                  // style: TextStyle(color: Colors.black),);
                },
                ),
              ),
            ),
          );
        }
        else{
          return Container();
        }
      },
    );
  }

  Widget bottomSheet(WorkExperience workExperience){
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
                      return 'Please enter Company Name';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  onSaved: (value){
                    workExperience.companyName=value;
                  },
                  enabled: true,
                  initialValue: workExperience.companyName,
                  decoration: InputDecoration(
                      labelText: 'Company Name*',
                      // border: OutlineInputBorder()
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
                  onSaved: (value){
                    workExperience.jobTitle=value;
                  },
                  enabled: true,
                  initialValue: workExperience.jobTitle,
                  decoration: InputDecoration(
                      labelText: 'Job Title',
                      // border: OutlineInputBorder()
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'd MMM, yyyy',
                        initialValue: workExperience.startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Start Date*',
                        onChanged: (value) => print(value),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Date';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          workExperience.startDate=value;
                        },
                      )
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          initialValue: workExperience.endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          icon: Icon(Icons.event),
                          dateLabelText: 'End Date*',
                          onChanged: (value) => print(value),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Date';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            workExperience.endDate=value;
                          },
                        )
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  onSaved: (value){
                    workExperience.details=value;
                  },
                  enabled: true,
                  initialValue: workExperience.details,
                  decoration: InputDecoration(
                      labelText: 'Details',
                      // border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32,8,32,8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          addToList(workExperience);
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

