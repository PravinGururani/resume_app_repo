import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/resume.dart';
import 'package:resume/model/resume_data.dart';
import 'package:resume/utility/get_resume_data.dart';

import 'create_resume.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {

  List<Resume> resumeList = new List<Resume>();


  Future<List<Resume>> getAllResumes() async {
    await DatabaseProvider.db.getAllResumes().then((value) {
      resumeList = value;
      print(value[0].personName);
    });
    return resumeList;
  }


  final myController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  Resume newResume=new Resume();

  createResume() async{
    newResume.name=myController.text;
    int resumeId=await DatabaseProvider.db.insertResume(newResume);
    myController.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateResume(resumeId: resumeId)));

  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllResumes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                title: Center(child: Text("My Resumes",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.add,
                        size: 35,),
                      onPressed:  () {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Resume"),
                            content: TextFormField(
                              controller: myController,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              autofocus: false,
                              onSaved: (value){
                                newResume.name=value;
                              },
                              enabled: true,
                              //initialValue: widget.service,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                //border: OutlineInputBorder()
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  createResume();
                                },
                                child: Text("CREATE"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              body: ListView.builder(
                  itemCount:resumeList.length,
                  itemBuilder: (context,index){
                    Uint8List _bytesImage;
                    if(snapshot.data[index].image!=null){
                      print(snapshot.data[index].image);
                      _bytesImage = Base64Decoder().convert(snapshot.data[index].image);
                    }

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: Card(
                            child: Container(
                              color: Colors.white10,
                              child: Row(
                                children: [/*
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover, image: MemoryImage(base64Decode(snapshot.data[index].image),)),
                                      shape: BoxShape.circle,
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _bytesImage==null
                                        ?
                                    Image.asset('resources/dummy_profile.png',height: 80, width:80, fit: BoxFit.fill,)
                                        :
                                    Image.memory(_bytesImage,height: 80, width:80, fit: BoxFit.fill,),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${snapshot.data[index].name}',
                                            style: TextStyle(
                                                fontSize: 30
                                            ),),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(icon: Icon(Icons.edit), onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateResume(resumeId: snapshot.data[index].id)));
                                            }),
                                            IconButton(icon: Icon(Icons.delete), onPressed: ()async{
                                              await DatabaseProvider.db.deleteResumeById(snapshot.data[index].id);
                                              setState(() {

                                              });
                                            }),
                                            //IconButton(icon: Icon(Icons.share), onPressed: null),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          else {
            return Container(
              child: Text('No Resume to Display'),
            );
          }
        }
    );
  }
}