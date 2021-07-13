import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/event/attendee_tile.dart';
import 'package:myapp/services/database.dart';

class FriendList extends StatefulWidget {

  final List<dynamic> friendsID;

  FriendList({ required this.friendsID });

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<UserData> _friends = [];

  void getFriends() {
    widget.friendsID.forEach((friend) async {
      await DatabaseService.getUserData(friend).then((friendData) {
        setState(() {
          _friends.add(friendData);
        });
      });
    });
  }

  @override
  void initState() {
    getFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_friends.isEmpty) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _friends.length + 1,
        itemBuilder: (context, index) {
          if (index != _friends.length) {
            return AttendeeTile(attendee: _friends[index]);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
              child: SvgPicture.asset('assets/tree.svg'),
            );
          }
        }
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/background.svg',
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Friends'),
            toolbarHeight: 100,
          ),
          body: Container(
            child: content,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          )
        ),
      ],
    );
  }
}
