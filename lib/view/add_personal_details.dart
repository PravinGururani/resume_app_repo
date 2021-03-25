import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/misc/utility.dart';
import 'package:resume/model/personal_details.dart';
import 'package:resume/view/add_skills.dart';
import 'dart:io';

class AddPersonalDetails extends StatefulWidget {
  @override
  _AddPersonalDetailsState createState() => _AddPersonalDetailsState();

  AddPersonalDetails({@required this.resumeId});
  final int resumeId;
}

class _AddPersonalDetailsState extends State<AddPersonalDetails> {
  Future myFuture;
  final formKey = new GlobalKey<FormState>();
  PersonalDetails personalDetails=new PersonalDetails();
  File _image;


  @override
  void initState() {
    // assign this variable your Future
    myFuture = getPersonalDetails();
    super.initState();
  }

  _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 200.0, maxHeight: 200.0
    );
    Uint8List data = await pickedFile.readAsBytes();
    String imgString = Utility.base64String( data);
    personalDetails.image=imgString;

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  _imgFromGallery() async {
    final pickedFile = await  ImagePicker().getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 200.0, maxHeight: 200.0
    );
    Uint8List data = await pickedFile.readAsBytes();
    String imgString = Utility.base64String( data);
    personalDetails.image=imgString;

    setState(() {
      _image = File(pickedFile.path);
    });
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  addUpdatePersonalDetails(PersonalDetails personalDetails) async {
    personalDetails.resumeId=widget.resumeId;
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await DatabaseProvider.db.addUpdatePersonalDetails(personalDetails);
      await DatabaseProvider.db.getResume(widget.resumeId).then((value) {
        value.personName=personalDetails.name;
        value.image=personalDetails.image;
        print(value.personName);
        DatabaseProvider.db.updateResume(value);
      });
      setState(() {
      });
      getPersonalDetails();
    }
  }

  Future <PersonalDetails> getPersonalDetails() async{
    print(personalDetails);
    await DatabaseProvider.db.getPersonalDetails(widget.resumeId).then((value) {
      if(value!=null) {
        personalDetails = value;
      }
    });
    return personalDetails;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
                    Center(
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            child: ClipOval(child: personalDetails.image!=null?
                            Utility.imageFromBase64String(personalDetails.image)
                                :
                            Image.asset("resources/dummy_profile.png",
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,),
                            ),
                          ),
                          Positioned(bottom: 1, right: 1, child: Container(
                            height: 40, width: 40,
                            child: IconButton(icon: Icon(Icons.add_a_photo,),
                              onPressed:() {
                                _showPicker(context);
                              },
                            ),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20))
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        autofocus: false,
                        onSaved: (value) {
                          personalDetails.name = value;
                        },
                        enabled: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                        initialValue: snapshot.data == null ||
                            snapshot.data.name == null ? "" : snapshot.data
                            .name,
                        decoration: InputDecoration(
                          labelText: 'Name',
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
                        onSaved: (value) {
                          personalDetails.jobTitle = value;
                        },
                        enabled: true,
                        initialValue: snapshot.data == null ||
                            snapshot.data.jobTitle == null
                            ? ""
                            : snapshot.data.jobTitle,
                        decoration: InputDecoration(
                          labelText: 'Job Title',
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
                        onSaved: (value) {
                          personalDetails.email = value;
                        },
                        enabled: true,
                        initialValue: snapshot.data == null ||
                            snapshot.data.email == null ? "" : snapshot.data
                            .email,
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Phone';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          personalDetails.phone = int.parse(value);
                        },
                        enabled: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: snapshot.data == null ||
                            snapshot.data.phone == null ? "" : snapshot.data
                            .phone.toString(),
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          //border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        minLines: 4,
                        maxLines: 5,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        autofocus: false,
                        onSaved: (value) {
                          personalDetails.professionalSummary = value;
                        },
                        enabled: true,
                        initialValue: snapshot.data == null ||
                            snapshot.data.professionalSummary == null
                            ? ""
                            : snapshot.data.professionalSummary,
                        decoration: InputDecoration(
                          labelText: 'Professional Summary',
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
                        onSaved: (value) {
                          personalDetails.address = value;
                        },
                        enabled: true,
                        initialValue: snapshot.data == null ||
                            snapshot.data.address == null ? "" : snapshot.data
                            .address,
                        decoration: InputDecoration(
                          labelText: 'City and Country',
                          //border: OutlineInputBorder()
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: ()  {
                addUpdatePersonalDetails(personalDetails);
              },
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Save',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        );
      }
      else {
        return Container();
      }
    });}
    }

