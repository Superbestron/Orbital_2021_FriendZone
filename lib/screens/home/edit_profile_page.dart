import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/home/profile_widget.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';

class EditProfilePage extends StatefulWidget {

  final UserData userData;
  final ImageProvider profileImage;

  const EditProfilePage({
    required this.userData,
    required this.profileImage
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late File _imageFile;
  final picker = ImagePicker();
  String _name = '';
  String _bio = '';
  final _formKey = GlobalKey<FormState>();
  late DatabaseService dbService;
  late UserData userData;
  ImageProvider? _currentImage;

  void initState() {
    dbService = DatabaseService(uid: widget.userData.uid);
    userData = widget.userData;
    _name = userData.name;
    _bio = userData.bio;
    _currentImage = widget.profileImage;
    super.initState();
  }

  Future getImageFromGallery() async {
    final PickedFile? pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _currentImage = FileImage(_imageFile);
      } else {
        print('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SvgPicture.asset(
          'assets/background.svg',
            fit: BoxFit.cover,
          ),
          Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.black),
              title: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black),
              ),
              toolbarHeight: 100,
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  // TODO: HERE
                  image: _currentImage ?? AssetImage('assets/default-profile-pic.jpeg'),
                  isEdit: true,
                  onClicked: () async {
                    getImageFromGallery();
                  }
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Full Name', style: BOLDED_NORMAL),
                      ),
                      TextFormField(
                        initialValue: userData.name,
                        decoration: textInputDecoration.copyWith(hintText: 'Full Name'),
                        validator: (val) => val!.isEmpty ? 'Name cannot be blank' : null,
                        onChanged: (val) => setState(() { _name = val; }),
                      ),
                    ]
                  )
                ),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('About', style: BOLDED_NORMAL),
                ),
                TextFormField(
                  initialValue: userData.bio,
                  decoration: textInputDecoration.copyWith(hintText: 'Say something about yourself!'),
                  onChanged: (val) => setState(() { _bio = val; }),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      userData.profileImagePath =
                        await dbService.uploadImageToFirebase(_imageFile, userData);
                      await dbService
                        .updateUserData(
                          userData.profileImagePath, _name, userData.level, userData.faculty,
                          userData.points, _bio, userData.events,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: GREEN_1,
                          content: Text('Successfully edited your profile!')
                        )
                      );
                    }
                  },
                ),
                const SizedBox(height: 60),
                SvgPicture.asset(
                  'assets/tree.svg',
                  // fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge
                ),
              ]
            )
          ),
        ]
      ),
    );
  }
}
