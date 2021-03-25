import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/resume.dart';
import 'package:resume/view/create_resume.dart';
import 'add_personal_details.dart';
import 'package:marquee/marquee.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  int _currentIndex=0;
}

class _HomeState extends State<Home> {

  String advText1='What is the best way for Employers to contact you?';

  List<Widget> carouselCardList=[
    Carousel(imageUrl: 'resources/carousel.jpg'),
    Carousel(imageUrl: 'resources/carousel.jpg'),
    Carousel(imageUrl: 'resources/carousel.jpg'),
    Carousel(imageUrl: 'resources/carousel.jpg'),
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(child: Text("Home",
          style: TextStyle(
              color: Colors.white
          ),

        ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                aspectRatio: 16/9,
                onPageChanged: (index, reason) {
                  setState(() {
                    widget._currentIndex = index;
                  });
                },
              ),
              items: carouselCardList,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(carouselCardList, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget._currentIndex == index ? Color.fromRGBO(242, 187, 19, 1) : Colors.grey,
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250.0,
                child: Center(
                  child: Text('TEMPLATES',
                    style: TextStyle(
                        fontFamily: 'Horizon',
                        fontSize: 40
                    ),),

                  /*ScaleAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        "Think",
                        "Select",
                        "Build"
                      ],
                      textStyle: TextStyle(
                          fontSize: 70.0,
                          fontFamily: "Canterbury"
                      ),
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                  ),*/
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              color: Colors.black12,
              height: 250.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Card(
                    child: Container(
                      width: 180,
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Image.asset('resources/temp1.png',fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 180,
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Image.asset('resources/temp1.png',fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 180,
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Image.asset('resources/temp1.png',fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 180,
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Image.asset('resources/temp1.png',fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 180,
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Image.asset('resources/temp1.png',fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 180.0,
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Center(child: Text('More >>>>',
                            style: TextStyle(
                                fontFamily: 'Horizon',
                                fontSize: 40
                            ),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: BlinkText(
                '**link to some article',
                style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                beginColor: Colors.black,
                endColor: Colors.orange,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: BlinkText(
                '**link to some article',
                style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                beginColor: Colors.yellow,
                endColor: Colors.green,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: BlinkText(
                '**link to some article',
                style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                beginColor: Colors.black,
                endColor: Colors.orange,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: BlinkText(
                '**link to some article',
                style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                beginColor: Colors.yellow,
                endColor: Colors.green,
                textAlign: TextAlign.start,
              ),
            ),*/

            /*Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: Container(
                height: 50,
                child: Marquee(
                    text: advText1,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Colors.grey[850],
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 50,
                    velocity: 100,
                    pauseAfterRound: Duration(seconds: 2),
                    decelerationDuration: Duration(seconds: 2),
                    startPadding: 100
                ),
              ),
            ),*/
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add, size: 40,),
          onPressed: () {
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
    );
  }
}

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
  final String imageUrl;
  Carousel({@required this.imageUrl});
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(widget.imageUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
