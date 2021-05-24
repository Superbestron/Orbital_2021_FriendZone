import 'package:myapp/screens/home/brew_list.dart';
import 'package:myapp/screens/home/settings_form.dart';
import 'package:myapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/brew.dart';

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

    return StreamProvider<List<Brew>?>.value(
      initialData: null,
      value: DatabaseService(uid: '').brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
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
          child: BrewList(),
        ),
      )
    );
  }
}
