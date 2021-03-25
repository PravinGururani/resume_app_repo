import 'package:flutter/material.dart';
import 'package:resume/model/work_experience.dart';
class AddWorkExperienceDialogue extends StatefulWidget {
  @override
  _AddWorkExperienceDialogueState createState() => _AddWorkExperienceDialogueState();
}

class _AddWorkExperienceDialogueState extends State<AddWorkExperienceDialogue> {
  final formKey = new GlobalKey<FormState>();
  WorkExperience workExperience=new WorkExperience();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Text("DIALOGUE BOX"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            style: TextStyle(
              color: Colors.grey,
            ),
            autofocus: false,
            onSaved: (value){
              workExperience.companyName=value;
            },
            enabled: true,
            //initialValue: widget.service,
            decoration: InputDecoration(
                labelText: 'Client Name',
                border: OutlineInputBorder()
            ),
          ),
        ),
        /*
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: Text('WORK EXPERIENCE')),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    autofocus: false,
                    onSaved: (value){
                      workExperience.projectName=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Project Name',
                        border: OutlineInputBorder()
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
                      workExperience.clientName=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Client Name',
                        border: OutlineInputBorder()
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
                      workExperience.role=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder()
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
                      workExperience.description=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Project Description',
                        border: OutlineInputBorder()
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
                      workExperience.contribution=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Contribution',
                        border: OutlineInputBorder()
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
                      workExperience.techStack=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Technologies',
                        border: OutlineInputBorder()
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
                      workExperience.duration=value;
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Project Duration',
                        border: OutlineInputBorder()
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
                      workExperience.teamSize=int.parse(value);
                    },
                    enabled: true,
                    //initialValue: widget.service,
                    decoration: InputDecoration(
                        labelText: 'Team Size',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: (){

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
          ),
        ),*/
      ],
    );
  }
}
