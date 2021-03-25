import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/misc/my_text_field_date_picker.dart';
import 'package:resume/model/personal_details.dart';
import 'package:resume/model/project_details.dart';
import 'package:resume/view/reusable_widgets.dart';

import 'colors/colors.dart';
class AddProjects extends StatefulWidget {
  @override
  _AddProjectsState createState() => _AddProjectsState();

  AddProjects({@required this.resumeId});
  final int resumeId;
}

class _AddProjectsState extends State<AddProjects> {
  final formKey = new GlobalKey<FormState>();
  List<ProjectDetails> listProjectDetails=[];

  addToList(ProjectDetails projectDetails) async{
    projectDetails.resumeId=widget.resumeId;
    print("TEST:${widget.resumeId}");
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await DatabaseProvider.db.addUpdateProjectDetails(projectDetails);
      listProjectDetails.clear();
      setState(() {
      });
      Navigator.pop(context);
    }
  }

  Future <List<ProjectDetails>> getAllProjectDetails() async{
    await DatabaseProvider.db.getAllProjectDetails(widget.resumeId).then((value) {
      listProjectDetails=value;
    });
    return listProjectDetails;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllProjectDetails(),
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
                        return SafeArea(
                          child: Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: bottomSheet(new ProjectDetails()),
                          ),
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
                                        DatabaseProvider.db.deleteProjectDetailsById(snapshot.data[index].id);

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
                              flex: 9,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Text("${snapshot.data[index].projectName}",
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
                                            Text("${snapshot.data[index].startDate.toString().substring(0,4)} - ${snapshot.data[index].endDate.toString().substring(0,4)}",
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
                                        Text("${snapshot.data[index].clientName}",
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
                                          child: Text("${snapshot.data[index].role}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("${snapshot.data[index].description}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("${snapshot.data[index].techStack}",
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
                  // return Text("${listProjectDetails[index].companyName}",
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

  Widget bottomSheet(ProjectDetails projectDetails){
    return Form(
      key: formKey,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  autofocus: false,
                  onSaved: (value){
                    projectDetails.projectName=value;
                  },
                  enabled: true,
                  initialValue: projectDetails.projectName,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Project Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Project Name*',
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
                  initialValue: projectDetails.clientName,
                  onSaved: (value){
                    projectDetails.clientName=value;
                  },
                  enabled: true,
                  decoration: InputDecoration(
                      labelText: 'Client Name',
                      //border: OutlineInputBorder()
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
                          initialValue: projectDetails.startDate,
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
                            projectDetails.startDate=value;
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
                          initialValue: projectDetails.endDate,
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
                            projectDetails.endDate=value;
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
                    projectDetails.role=value;
                  },
                  enabled: true,
                  initialValue: projectDetails.role,
                  decoration: InputDecoration(
                      labelText: 'Role',
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
                  onSaved: (value){
                    projectDetails.description=value;
                  },
                  enabled: true,
                  initialValue: projectDetails.description,
                  decoration: InputDecoration(
                      labelText: 'Description',
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
                  onSaved: (value){
                    projectDetails.techStack=value;
                  },
                  enabled: true,
                  initialValue: projectDetails.techStack,
                  decoration: InputDecoration(
                      labelText: 'Skills/Technology Used',
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
                  onSaved: (value){
                    if(value!=""){
                      projectDetails.teamSize=int.parse(value);
                    }
                  },
                  enabled: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  initialValue: projectDetails == null ||
                      projectDetails.teamSize == null ? "" : projectDetails.teamSize.toString(),
                  decoration: InputDecoration(
                      labelText: 'Team Size',
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
                      onPressed: (){
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
                          addToList(projectDetails);
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

