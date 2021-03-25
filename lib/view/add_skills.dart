import 'package:flutter/material.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/skills.dart';
import 'package:resume/model/work_experience.dart';
import 'package:resume/view/add_work_experience.dart';
class AddSkills extends StatefulWidget {
  @override
  _AddSkillsState createState() => _AddSkillsState();
  AddSkills({@required this.resumeId});
  final int resumeId;
}

class _AddSkillsState extends State<AddSkills> {

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final myController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  List<Skills> listSkills=[];

  addToList(Skills skills) async{
    skills.name=myController.text;
    skills.resumeId=widget.resumeId;
    print("TEST:${widget.resumeId}");
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await DatabaseProvider.db.insertSkills(skills);
      listSkills.clear();
      setState(() {
      });
      myController.clear();
      Navigator.pop(context);
    }
  }

  Future <List<Skills>> getAllSkills() async{
    await DatabaseProvider.db.getAllSkills(widget.resumeId).then((value) {
      listSkills=value;
    });
    return listSkills;
  }

  Widget showSkills(AsyncSnapshot snapshot)
  {
    return Expanded(
      flex: 5,
      child: GridView.count(crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      childAspectRatio: 3,
      children: List.generate(snapshot.data.length, (index){
        return InputChip(label: Text(snapshot.data[index].name),
          onDeleted: (){
          setState(() {
            DatabaseProvider.db.deleteSkillById(snapshot.data[index].id);
          });
          },
          deleteIconColor: Colors.black54,);
      },
      ),
      ),
    );


    // List<Widget> list = new List<Widget>();
    // for(var i = 0; i < strings.length; i++){
    //   list.add(new Text(strings[i]));
    // }
    // return new Row(children: list);
  }

  Widget skill(String skill){
    return Text("$skill");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllSkills(),
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    showSkills(snapshot),
                    RaisedButton(
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (ctx) {
                            return addSkillDialogue();
                          }
                        );
                      },
                      child: Text("ADD SKILL"),
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                          onTap: (){
                            //addSkillToList();
                          },
                          child: Text('')),
                    ),
                  ],
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

  Widget addSkillDialogue() {
    Skills skills=new Skills();
    return AlertDialog(
      title: Text("Add Skill"),
      content: TextFormField(
        controller: myController,
        style: TextStyle(
          color: Colors.grey,
        ),
        autofocus: false,
        onSaved: (value){
          skills.name;
        },
        enabled: true,
        //initialValue: widget.service,
        decoration: InputDecoration(
          labelText: 'Skill',
          //border: OutlineInputBorder()
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            addToList(skills);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}