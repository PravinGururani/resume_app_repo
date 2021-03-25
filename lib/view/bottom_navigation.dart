import 'package:flutter/material.dart';
import 'package:resume/view/Profiles.dart';
import 'account.dart';
import 'home.dart';
import 'my_resume.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
  final int index;
  BottomNavigation({@required this.index});
}

class _BottomNavigationState extends State<BottomNavigation> {

  //Future<UserLogin> getUserData() => UserPreferences().getUser();

  int _currentIndex = 0;
  // int _routeIndex;
  // Color _selectedColor=Colors.black45;
  final List<Widget> _children = [
    Home(),
    Profiles(),
    MyResume(),
    //Account(),
  ];

  // final List<Color> _color=[
  //   Colors.amberAccent,
  //   Colors.amberAccent,
  //   Colors.amberAccent,
  // ];
  //
  // Color setColor()
  // {
  //
  //   return Colors.pink;
  // }

  // void onTabTapped(int index) {
  //   if(index==1){
  //     getUserData().then((value) => value.accessToken==null
  //         ?
  //     setState((){
  //       print('test 1');
  //       Navigator.push(context,
  //           MaterialPageRoute(builder:
  //               (context) =>
  //               PleaseLogin(route : 'ALL BOOKINGS')
  //           )
  //       );
  //     })
  //         :
  //     setState(() {
  //       print('test 2');
  //       _currentIndex = index;
  //       _routeIndex=index;
  //     })
  //     );
  //   }
  //   else{
  //     setState(() {
  //       print('test 3');
  //       _currentIndex = index;
  //       _routeIndex=index;
  //     });
  //   }
  // }
  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _routeIndex=widget.index;
    if(widget.index!=null){
      _currentIndex=widget.index;
    }
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            //canvasColor: Colors.green,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home,),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,),
                label: 'Profiles'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book,),
              label: 'My Resumes'
            ),
            /*BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
                label: 'Account'
            ),*/
          ],
          selectedItemColor: Colors.orange,
          onTap: (index){
            setState(() {
              _currentIndex=index;
            });
          },
          currentIndex: _currentIndex,
        ),
      ),
    );
  }
}
