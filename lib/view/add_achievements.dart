import 'package:flutter/material.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/achievements.dart';
import 'package:resume/view/reusable_widgets.dart';

import 'colors/colors.dart';
class AddAchievements extends StatefulWidget {
  @override
  _AddAchievementsState createState() => _AddAchievementsState();

  AddAchievements({@required this.resumeId});
  final int resumeId;
}

class _AddAchievementsState extends State<AddAchievements> {
  final formKey = new GlobalKey<FormState>();
  List<Achievements> listAchievements=[];

  addToList(Achievements achievements) async{
    achievements.resumeId=widget.resumeId;
    print("TEST:${widget.resumeId}");
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await DatabaseProvider.db.addUpdateAchievements(achievements);
      listAchievements.clear();
      setState(() {
      });
      Navigator.pop(context);
    }
  }

  Future <List<Achievements>> getAllAchievements() async{
    await DatabaseProvider.db.getAllAchievements(widget.resumeId).then((value) {
      listAchievements=value;
    });
    return listAchievements;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllAchievements(),
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
                          child: bottomSheet(new Achievements()),
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
                                        DatabaseProvider.db.deleteAchievementsById(snapshot.data[index].id);

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
                                          Text("${snapshot.data[index].achievement}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                        ),
                                        Row(children: [
                                          Text("${snapshot.data[index].year}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
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
                  // return Text("${listAchievements[index].companyName}",
                  // style: TextStyle(color: Colors.black),);
                },
                ),
              ),
              /*bottomNavigationBar: GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddAchievementsDialogue();
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

  Widget bottomSheet(Achievements achievements){
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
                    achievements.achievement=value;
                  },
                  enabled: true,
                  initialValue: achievements.achievement,
                  decoration: InputDecoration(
                      labelText: 'Achievement/Awards/Certification',
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
                  initialValue: achievements.year==null ? "" : achievements.year.toString(),
                  onSaved: (value){
                    achievements.year=int.parse(value);
                  },
                  enabled: true,
                  //initialValue: widget.service,
                  decoration: InputDecoration(
                      labelText: 'Year',
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
                      onPressed: () => addToList(achievements),
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

