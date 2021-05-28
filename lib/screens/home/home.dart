import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/screens/home/create_event.dart';
import 'package:myapp/screens/home/profile.dart';
import 'package:myapp/screens/home/screen1.dart';
import 'package:myapp/screens/home/screen2.dart';
import 'package:myapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  final AuthService _auth = AuthService();
  PageController _pageController = PageController();
  final List<Widget> _children = [
    EventList(query: ''),
    Screen1(),
    CreateEvent(),
    Screen2(),
    Profile(),
  ];
  final List<String> _appBarTitles = [
    'List of Events',
    'Screen 1',
    'Create New Event',
    'Screen 2',
    'My Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  String query = "";

  @override
  Widget build(BuildContext context) {

    // void _showSettingsPanel() {
    //   showModalBottomSheet(context: context, builder: (context) {
    //     return Container(
    //       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
    //       child: SettingsForm(),
    //     );
    //   });
    // }

    return StreamProvider<List<Event>?>.value(
      initialData: null,
      value: DatabaseService(uid: '').events,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget> [
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Text(_appBarTitles[_selectedIndex],
                  style: TextStyle(
                      color: Colors.black,
                  ),
              ),
              backgroundColor: Colors.transparent,
              toolbarHeight: 100.0,
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.person, color: Colors.black),
                  label: Text('logout', style: TextStyle(color: Colors.black)),
                  onPressed: () async { await _auth.signOut(); }
                ),
                SizedBox(width: 20.0),
                // TextButton.icon(
                //   icon: Icon(Icons.settings),
                //   label: Text('settings'),
                //   onPressed: () => _showSettingsPanel(),
                // ),
                // SizedBox(width: 20.0),
              ],
            ),

            body: Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/...png'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: PageView(
                controller: _pageController,
                children: _children,
                onPageChanged: _onItemTapped,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.lightBlue[400],
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Create',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_alert),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.perm_identity),
                  label: 'My Profile',
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
