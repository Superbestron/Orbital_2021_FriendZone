import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_list.dart';
import 'package:myapp/screens/home/settings_form.dart';
import 'package:myapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/navigation.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Event>?>.value(
      initialData: null,
      value: DatabaseService(uid: '').events,
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async { await _auth.signOut(); }
            ),
            SizedBox(width: 20.0),
            TextButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: () => _showSettingsPanel(),
            ),
            SizedBox(width: 20.0),
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/...png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: EventList(),
        ),
        bottomNavigationBar: NavigationBar(),
      )
    );
  }
}
