import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitlah/services/user_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';
import '../../widgets/primary_button_widget.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? _userModel;
  String? username = "";
  double? height = 0.0;
  double? weight = 0.0;
  int? age = 0;
  bool _isLoading = false;
  final bool _isUploading = false;
  var form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<String?> getProfileImage(String imagePath) async {
    return await FirebaseStorage.instance
        .ref()
        .child(imagePath)
        .getDownloadURL();
  }

  void saveForm(BuildContext context) async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
    }

    final Map<String, dynamic> map = {};
    if (username != _userModel!.username) {
      map["username"] = username;
    }
    if (weight != _userModel!.weight) {
      map["weight"] = weight;
    }
    if (height != _userModel!.height) {
      map["height"] = height;
    }
    if (age != _userModel!.age) {
      map["age"] = age;
    }
    if (map.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      const SnackBar(
        content: Text("No data has been changed"),
      );
    }

    try {
      bool updateResults = await UserService.instance().updateUser(map, null);

      setState(() {
        _isLoading = false;
      });

      if (!updateResults) {
        const SnackBar(
          content: Text("Unknown Error has occured"),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text((e as FirebaseException).message.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: themeColor, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text("Fitlah"),
      ),
      body: StreamBuilder<UserModel?>(
          stream: UserService.instance().getUserStream(),
          builder: (context, user) {
            if (user.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (user.hasData) {
              _userModel = user.data;
              username = _userModel?.username;
              weight = _userModel?.weight;
              height = _userModel?.height;
              age = _userModel?.age;
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Profile Image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Material(
                          color: Colors.transparent,
                          child: user.data?.profileImage != null
                              ? SizedBox(
                                  width: 128,
                                  height: 128,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(
                                      user.data!.profileImage!,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        if (loadingProgress
                                                .expectedTotalBytes ==
                                            null) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        double percentLoaded = loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!;
                                        return CircularProgressIndicator(
                                          value: percentLoaded,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 128,
                                  height: 128,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.asset('images/user.png'),
                                  ),
                                )),
                    ),
                    Column(
                      children: [
                        TextButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () => pickImageProfile(0),
                            label: const Text('Take Photo')),
                        TextButton.icon(
                            icon: const Icon(Icons.image),
                            onPressed: () => pickImageProfile(1),
                            label: const Text('Add Image')),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: form,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(username!, false, false, false),
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(weight!.toString(), false, true, false),
                        const Text(
                          'Age',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(age!.toString(), false, false, true),
                        const Text(
                          'Height',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(height!.toString(), true, false, false),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              saveForm(context);
                            },
                            child: const PrimaryButton(
                              buttonText: 'Save',
                              buttonColor: themeColor,
                            ),
                          ),
                        )
                      ]),
                )
              ],
            );
          }),
    );
  }

  Widget buildTextField(
      String initialText, bool isHeight, bool isWeight, bool isAge) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialText,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(textColor1)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(textColor1)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(fontSize: 14, color: Color(textColor1)),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(35.0))),
        ),
        validator: (value) {
          if (isAge) {
            if (value == null || value.isEmpty) {
              return "Please state your age ";
            } else {
              return null;
            }
          } else if (isHeight) {
            if (value == null || value.isEmpty) {
              return "Please enter your Height in (cm)";
            } else {
              return null;
            }
          } else if (isWeight) {
            if (value == null || value.isEmpty) {
              return "Please enter your Weight in (kg) ";
            } else {
              return null;
            }
          } else {
            if (value == null || value.isEmpty) {
              return "Please enter your username";
            } else if (value.length < 6) {
              return 'Username must be at least 6 characters';
            } else {
              return null;
            }
          }
        },
        onSaved: (value) {
          if (isAge) {
            age = int.parse(value!);
          } else if (isWeight) {
            weight = double.parse(value!);
          } else if (isHeight) {
            height = double.parse(value!);
          } else {
            username = value.toString();
          }
        },
      ),
    );
  }

  void pickImageProfile(mode) async {
    ImageSource chosenSource =
        mode == 0 ? ImageSource.camera : ImageSource.gallery;
    return ImagePicker()
        .pickImage(
      source: chosenSource,
      imageQuality: 100,
    )
        .then((imageFile) async {
      if (imageFile == null) return;

      bool results =
          await UserService.instance().updateUser({}, File(imageFile.path));
    });
  }
}
