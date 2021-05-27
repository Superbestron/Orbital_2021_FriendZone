import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_list.dart';
import 'package:myapp/screens/home/settings_form.dart';
import 'package:myapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  String query = "";

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
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,

            // app bar to change settings and logout
            // left for ease of logout, intend to put logout somewhere else

            // appBar: AppBar(
            //   title: Text('Brew Crew'),
            //   backgroundColor: Colors.brown[400],
            //   elevation: 0.0,
            //   actions: <Widget>[
            //     TextButton.icon(
            //         icon: Icon(Icons.person),
            //         label: Text('logout'),
            //         onPressed: () async { await _auth.signOut(); }
            //     ),
            //     SizedBox(width: 20.0),
            //     TextButton.icon(
            //       icon: Icon(Icons.settings),
            //       label: Text('settings'),
            //       onPressed: () => _showSettingsPanel(),
            //     ),
            //     SizedBox(width: 20.0),
            //   ],
            // ),

            body: Column(
              children: <Widget>[
                Container(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Search Event by Name',
                        fillColor: CARD_BACKGROUND,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() { query = val; }),
                  ),
                ),
                Expanded(
                  child: EventList(query: query),
                )
              ],
            ),
            bottomNavigationBar: NavigationBar(),
          )
        ],
      ),
    );
  }
}
