import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/profile/profile_widget.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:image_cropper/image_cropper.dart';

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

  bool _hasDeletedProfileImage = false;
  bool _hasChosenNewImage = false;
  late File _imageFile;
  final picker = ImagePicker();
  String _name = '';
  String _bio = '';
  late String _faculty;
  final _formKey = GlobalKey<FormState>();
  late DatabaseService dbService;
  late UserData userData;
  ImageProvider? _currentImage;
  late List<String> _faculties;

  void initState() {
    dbService = DatabaseService(uid: widget.userData.uid);
    userData = widget.userData;
    _name = userData.name;
    _bio = userData.bio;
    _currentImage = widget.profileImage;
    _faculty = userData.faculty;
    _faculties = FACULTIES;
    super.initState();
  }

  Future _getImageFromGallery() async {
    final PickedFile? pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _currentImage = FileImage(_imageFile);
        _hasDeletedProfileImage = false;
        _hasChosenNewImage = true;

      } else {
        print('No Image Selected');
      }
    });
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: Platform.isAndroid
      ? [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
      ]
      : [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        showCropGrid: false,
        toolbarTitle: 'Crop Image',
        toolbarColor: ORANGE_1,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      )
    );
    if (croppedFile != null) {
      _imageFile = croppedFile;
      setState(() {
        _currentImage = FileImage(_imageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SvgPicture.asset(
          'assets/background.svg',
            fit: BoxFit.cover,
          ),
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: BackButton(color: Colors.black,),
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
                  isSelf: true,
                  image: _currentImage ?? DEFAULT_PROFILE_PIC,
                  isEdit: true,
                  onClicked: () async {
                    _getImageFromGallery();
                  }
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() { _currentImage = DEFAULT_PROFILE_PIC; });
                    _hasDeletedProfileImage = true;
                    _hasChosenNewImage = false;
                  },
                  child: Text('Remove Profile Image'),
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
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) => val!.isEmpty ? 'Name cannot be blank' : null,
                        onChanged: (val) => setState(() { _name = val; }),
                      ),
                    ]
                  )
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Faculty', style: BOLDED_NORMAL),
                ),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      minWidth: 300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        isExpanded: true,
                        items: _faculties
                            .map((faculty) {
                              print(_faculties.length);
                          return DropdownMenuItem(
                            value: faculty,
                            child: Text(faculty),
                          );
                        }).toList(),
                        menuMaxHeight: 300,
                        onChanged: (val) {
                          return setState(() { _faculty = val.toString(); });
                        },
                        value: _faculty,
                      ),
                    ),
                  ),
                  decoration: boxDecoration.copyWith(borderRadius: BorderRadius.all(Radius.circular(5))),
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
                      if (_hasDeletedProfileImage) {
                        // If user clicks on remove image button
                        await dbService.deleteImageFromFirebase(userData.profileImagePath);
                        userData.profileImagePath = '';
                      } else if (_hasChosenNewImage) {
                        // Else upload selected image
                        userData.profileImagePath =
                        await dbService.uploadImageToFirebase(_imageFile, userData);
                      }
                      await dbService
                        .updateUserData(
                          userData.profileImagePath, _name, userData.level, _faculty,
                          userData.points, _bio, userData.events, userData.notifications,
                          userData.friendRequests, userData.friends
                      );

                      // update in firebase profile authentication
                      await AuthService().updateDisplayName(_name);

                      // Go back to the profile page screen with the selected image
                      // (or default image if the user decides not to put an image)
                      Navigator.pop(context, _hasDeletedProfileImage
                          ? DEFAULT_PROFILE_PIC
                          : _currentImage);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: BACKGROUND_COLOR,
                          content: Text('Successfully edited your profile!'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {},
                          ),
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
      );
  }
}
