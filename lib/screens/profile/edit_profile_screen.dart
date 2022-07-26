import 'package:fitlah/services/user_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

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
  var form = GlobalKey<FormState>();

  void saveForm(BuildContext context) async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ProfileWidget(
                  imagePath:
                      'https://media.istockphoto.com/photos/portrait-of-a-handsome-black-man-picture-id1289461335?b=1&k=20&m=1289461335&s=170667a&w=0&h=7L30Sh0R-0JXjgqFnxupL9msH5idzcz0xZUAMB9hY_k=',
                  isEdit: true,
                  onClicked: () async {},
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
                        buildTextField(username!),
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          weight!.toString(),
                        ),
                        const Text(
                          'Age',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          age!.toString(),
                        ),
                        const Text(
                          'Height',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildTextField(
                          height!.toString(),
                        ),
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

  Widget buildTextField(String initialText) {
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
          if (value == null || value.isEmpty) {
            return "Please your FullName";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          username = value;
        },
      ),
    );
  }
}
