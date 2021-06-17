import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/screens/create_event/create_event.dart';
import 'package:myapp/screens/profile/profile_page.dart';
import 'package:myapp/screens/notifications/notifications_page.dart';
import 'package:myapp/screens/maps/maps.dart';
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
  late Function jumpToPage;
  late List<Widget> _children;

  @override
  void initState() {
    _children = [
      EventList(),
      Maps(),
      CreateEvent(jumpToPage: _onItemTapped),
      NotificationsWidget(),
      ProfilePage(profileID: ''),
    ];
    super.initState();
  }


  final List<String> _appBarTitles = [
    'Upcoming Events',
    'Events Near You',
    'Create New Event',
    'Notifications',
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
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(_appBarTitles[_selectedIndex],
                  ),
                  toolbarHeight: 100.0,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: TextButton.icon(
                        icon: Icon(Icons.person, color: Colors.black),
                        label: Text('logout', style: TextStyle(color: Colors.black)),
                        onPressed: () async { await _auth.signOut(); }
                      ),
                    ),
                  ],
                ),

                body: Container(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: _children,
                    onPageChanged: _onItemTapped,
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.cyan,
                  onTap: _onItemTapped,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.map_outlined),
                      label: 'Maps',
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
          ),
      );
  }
}
