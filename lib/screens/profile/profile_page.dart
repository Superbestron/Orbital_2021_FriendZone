import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/screens/profile/edit_profile_page.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:myapp/screens/profile/profile_widget.dart';
import 'package:provider/provider.dart';
import 'friend_list.dart';

class ProfilePage extends StatefulWidget {
  final String profileID;

  ProfilePage({
    required this.profileID,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImageProvider? _profileImage;
  String buttonText = '';
  Color buttonColor = ORANGE_1;
  Function onPressed = () {};

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    bool isSelf = widget.profileID.isEmpty;
    String userID = isSelf ? user!.uid : widget.profileID;
    DatabaseService dbServiceUser = DatabaseService(uid: userID);
    DatabaseService dbServiceSelf = DatabaseService(uid: user!.uid);
    List events = Provider.of<List<Event>?>(context) ?? [];


    void _urlToImage(String profileImagePath) {
      // if user did not upload any profile picture
      if (profileImagePath == '') {
        print('no image');
        _profileImage = DEFAULT_PROFILE_PIC;
      } else {
        DatabaseService
            .getImageURLFromFirebase(profileImagePath)
            .then((url) => setState(() {
                  _profileImage = NetworkImage(url);
                }));
      }
    }

    return StreamBuilder<UserData>(
      stream: dbServiceUser.userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;
          if (_profileImage == null) {
            _urlToImage(userData.profileImagePath);
          }
          return Scaffold(
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  // While the image is loading, show a white background (or loading animation)
                  isSelf: isSelf,
                  image: _profileImage ?? DEFAULT_PROFILE_PIC,
                  onClicked: () async {
                    if (isSelf) {
                      final _image = await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditProfilePage(
                            userData: userData,
                            profileImage: _profileImage ?? DEFAULT_PROFILE_PIC);
                      }));
                      setState(() {
                        _profileImage = _image;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                buildName(userData),
                isSelf
                  ? SizedBox(height: 36)
                  : StreamBuilder<UserData>(
                    stream: dbServiceSelf.userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // redeclaration of all variables here for clarity
                        String meID = user.uid;
                        String otherID = widget.profileID;
                        UserData me = snapshot.data!;
                        UserData other = userData;
                        // If I send friend request to person A, A's friendRequests
                        // list will have my ID
                        bool hasIncomingRequest = me.friendRequests.contains(otherID);
                        bool hasOutgoingRequest = other.friendRequests.contains(meID);
                        bool isFriends = me.friends.contains(otherID);
                        if (isFriends) {
                          buttonText = 'Delete Friend';
                          buttonColor = selectedColor!;
                          onPressed = () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Friend"),
                                content: Text(
                                    'Are you sure you want to delete \n${other.name} as friend?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel",
                                        style: TextStyle(
                                          color: Colors.red,
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await DatabaseService(uid: meID).deleteFriend(other.uid);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Confirm"),
                                  ),
                                ],
                              ),
                            );
                          };
                        } else if (hasIncomingRequest) {
                          buttonText = 'Accept Friend Request';
                          buttonColor = ORANGE_1;
                          onPressed = () async {
                            // user send friend request to profile
                            await dbServiceSelf.acceptFriend(widget.profileID);
                            await dbServiceSelf.sendFriendNotification(
                                "Accepted your friend request!",
                                user.uid,
                                widget.profileID);
                          };
                        } else if (hasOutgoingRequest) {
                          buttonText = 'Friend Request Sent';
                          buttonColor = Colors.grey;
                        } else {
                          buttonText = 'Add Friend';
                          buttonColor = ORANGE_1;
                          onPressed = () async {
                            // user send friend request to profile
                           await dbServiceSelf.addFriend(widget.profileID);
                           await dbServiceSelf.sendFriendNotification(
                                "Sent you a friend request!",
                                user.uid,
                                widget.profileID);
                          };
                        }
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Text(buttonText,
                                    style: TextStyle(
                                        color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  primary: buttonColor,
                                ),
                                onPressed: () => onPressed(),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return TransparentLoading();
                      }
                    }),
                NumbersWidget(
                  points: userData.points,
                  level: userData.level,
                  friends: userData.friends
                ),
                const SizedBox(height: 36),
                buildAbout(userData, isSelf),
                const SizedBox(height: 36),
                buildEventsAttended(events, userID, isSelf),
                const SizedBox(height: 36),
                SvgPicture.asset('assets/tree.svg',
                  // fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge),
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

Widget buildName(UserData userData) => Column(
      children: [
        Text(
          userData.name,
          style: TEXT_FIELD_HEADING,
        ),
        const SizedBox(height: 4),
        Text(
          userData.faculty,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );

class NumbersWidget extends StatelessWidget {
  final int points;
  final int level;
  final List<dynamic> friends;

  const NumbersWidget({
    Key? key,
    required this.points,
    required this.level,
    required this.friends,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              Icon(Icons.star),
              buildButton(context, '$points', 'Points', () {}),
            ],
          ),
          buildDivider(),
          Column(
            children: [
              Icon(Icons.trending_up),
              buildButton(context, '$level', 'Level', () {}),
            ],
          ),
          buildDivider(),
          Column(
            children: [
              Icon(Icons.social_distance),
              buildButton(context, '${friends.length}', 'Friends', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendList(friendsID: friends)));
              },),
            ],
          ),
        ],
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(color: Colors.grey),
      );

  Widget buildButton(BuildContext context, String value, String text, Function() onPressed) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: onPressed,
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

Widget buildAbout(UserData userData, bool isSelf) => Container(
      padding: EdgeInsets.symmetric(horizontal: isSelf ? 30 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('About', style: TEXT_FIELD_HEADING),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.short_text),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
                minWidth: 500,
              ),
              child: Text(userData.bio, style: NORMAL),
            ),
            decoration: boxDecoration,
            padding: const EdgeInsets.all(15.0),
          )
        ],
      ),
    );

Widget buildEventsAttended(List events, String uid, bool isSelf) =>
    StreamBuilder<UserData>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        UserData? userdata;
        if (snapshot.hasData) {
          userdata = snapshot.data!;
          // filter for events attended
          events = events.where((event) => userdata!.events.contains(event.eventID)).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isSelf ? 30 : 50),
              child: Row(
                children: [
                  Text('Recent Events Attended', style: TEXT_FIELD_HEADING),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.calendar_today),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isSelf ? 0 : 20),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    color: CARD_BACKGROUND,
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      minLeadingWidth: 10,
                      // dense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(events[index].name, style: TEXT_FIELD_HEADING),
                      ),
                      subtitle: Text(events[index].location, style: NORMAL),
                      trailing: IMAGE_LIST[events[index].icon],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPage(event: events[index]),
                        ),
                      )
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
);
