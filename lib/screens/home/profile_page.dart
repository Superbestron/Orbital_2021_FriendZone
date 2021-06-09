import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/home/edit_profile_page.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:myapp/screens/home/profile_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // late ImageProvider _image;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    var dbService = DatabaseService(uid: user!.uid);

    // Future _urlToImage(String profileImagePath) async {
    //   await dbService.getImageDataFromFirebase(profileImagePath).then((url) =>
    //     setState(() {
    //       _image = NetworkImage(url);
    //     })
    //   );
    // }

    return StreamBuilder<UserData>(
      stream: dbService.userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;
          return Scaffold(
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  // TODO: Edit profile pic
                  // image: userData.profileImage
                  image: AssetImage('assets/food.png'),
                  onClicked: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return EditProfilePage(userData: userData);
                      })
                    );
                  },
                ),
                const SizedBox(height: 24),
                buildName(userData),
                const SizedBox(height: 36),
                NumbersWidget(points: userData.points, level: userData.level),
                const SizedBox(height: 36),
                buildAbout(userData),
                const SizedBox(height: 36),
                SvgPicture.asset(
                    'assets/tree.svg',
                    // fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge
                ),
              ],
            ),
          );
        } else {
          return TransparentLoading();
        }
      },
    );
  }
}

Widget buildAbout(UserData userData) => Container(
  padding: EdgeInsets.symmetric(horizontal: 48),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('About', style: TEXT_FIELD_HEADING),
      const SizedBox(height: 16),
      Container(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100
          ),
          child: Text(userData.bio),
        ),
        decoration: boxDecoration,
        padding: const EdgeInsets.all(15.0),
      )
    ],
  ),
);

class NumbersWidget extends StatelessWidget {

  final int points;
  final int level;

  const NumbersWidget({
    Key? key,
    required this.points,
    required this.level
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Column(
        children: [
          Icon(Icons.star),
          buildButton(context, '$points', 'Points'),
        ],
      ),
      buildDivider(),
      Column(
        children: [
          Icon(Icons.mood),
          buildButton(context, '$level', 'level'),
        ],
      ),
      buildDivider(),
      // TODO: Possible button
      // buildButton(context, '$friends', 'Friends'),
      Column(
        children: [
          Icon(Icons.social_distance),
          buildButton(context, '50', 'Friends'),
        ],
      ),
    ],
  );
  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(color: Colors.grey),
  );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TEXT_FIELD_HEADING,
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: NORMAL,
            ),
          ],
        ),
      );
}

Widget buildName(UserData userData) => Column(
  children: [
    Text(
      userData.name,
      style: TEXT_FIELD_HEADING,
    ),
    const SizedBox(height: 4),
    Text(
      // '${userData.faculty}',
      // TODO: Allow users to choose from a list of faculties
      'School of Computing',
      style: TextStyle(color: Colors.grey),
    )
  ],
);
