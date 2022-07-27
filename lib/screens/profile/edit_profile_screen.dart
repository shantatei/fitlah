import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
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
  File? profileImage;
  bool _isLoading = false;
  final bool _isUploading = false;
  var form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
                              ? FittedBox(
                                  fit: BoxFit.fill,
                                  child:
                                      Image.network(user.data!.profileImage!))
                              : const FittedBox(
                                  fit: BoxFit.fill,
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.grey,
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

  // Widget _modalBottomSheedBuilder(BuildContext context) {
  //   return Container(
  //     height: 300,
  //     padding: const EdgeInsets.symmetric(
  //       vertical: 10,
  //       horizontal: 20,
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Container(
  //           clipBehavior: Clip.hardEdge,
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(15),
  //             ),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               SizedBox(
  //                 height: 50,
  //                 child: _modalItem(
  //                   text: "Choose from library",
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     _pickImage(_scaffoldKey, ImageSource.gallery);
  //                   },
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: _modalItem(
  //                   text: "Take Photo",
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     _pickImage(_scaffoldKey, ImageSource.camera);
  //                   },
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: _modalItem(
  //                   text: "Remove Current Photo",
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     _deletePhotoImage();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         Container(
  //           height: 50,
  //           clipBehavior: Clip.hardEdge,
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(15),
  //             ),
  //           ),
  //           child: _modalItem(
  //             text: "Cancel",
  //             onTap: () => Navigator.pop(context),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _modalItem({
  //   required String text,
  //   required void Function() onTap,
  // }) {
  //   return Material(
  //     child: InkWell(
  //       onTap: onTap,
  //       child: Ink(
  //         child: Center(
  //           child: Text(
  //             text,
  //             style: const TextStyle(
  //               fontFamily: 'Roboto',
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _deletePhotoImage() async {
  //   setState(() {
  //     _isLoading = true;
  //     _isUploading = true;
  //   });
  //   bool result = await UserService.instance().deleteUserImage();
  //   setState(() {
  //     _isLoading = false;
  //     _isUploading = false;
  //   });
  // }

  void pickImageProfile(mode) async {
    ImageSource chosenSource =
        mode == 0 ? ImageSource.camera : ImageSource.gallery;
    return ImagePicker()
        .pickImage(
            source: chosenSource,
            maxWidth: 600,
            imageQuality: 50,
            maxHeight: 150)
        .then((imageFile) async {
      // if (imageFile != null) {
      //   setState(() {
      //     profileImage = File(imageFile.path);
      //   });
      // }

      if (imageFile == null) return;

      bool results =
          await UserService.instance().updateUser({}, File(imageFile.path));
    });
  }
}
