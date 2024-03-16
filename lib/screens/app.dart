import 'package:donact/screens/activity/newActivity.dart';
import 'package:donact/screens/home/displayactivities.dart';
import 'package:donact/screens/messages/displaychats.dart';
import 'package:donact/screens/profile/profile.dart';
import 'package:donact/screens/search/SearchPage.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<App> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ActivitiesList(),
    Search(),
    NewActivity(),
    ChatsList(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Color.fromARGB(255, 132, 242, 92),
          selectedItemColor: Color.fromARGB(255, 242, 192, 92),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
