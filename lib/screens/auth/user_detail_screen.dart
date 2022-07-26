import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/services/user_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../widgets/primary_button_widget.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  var form = GlobalKey<FormState>();

  String username = "";

  double height = 0;

  double weight = 0;

  int age = 0;

  saveForm(BuildContext context) async {
    if (!form.currentState!.validate()) return;

    form.currentState!.save();
    try {
      bool insertResults = await UserService.instance().addUser(
        UserModel(
            username: username,
            email: AuthService().getCurrentUser()!.email!,
            height: height,
            weight: weight,
            age: age),
      );
      if (!insertResults) {
        const SnackBar(
          content: Text("Unknown Error has occured"),
        );
      }
    } catch (e) {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile Information",
            style: TextStyle(color: themeColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 50,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Fill up your Particulars",
                style: titleText,
              ),
            ),
            Form(
              key: form,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildTextField(
                      Icons.person,
                      "Username",
                      false,
                      false,
                      false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildTextField(
                      Icons.height,
                      "Height",
                      false,
                      true,
                      false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildTextField(
                      Icons.monitor_weight_outlined,
                      "Weight",
                      false,
                      false,
                      true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildTextField(
                      Icons.calendar_month_outlined,
                      "Age",
                      true,
                      false,
                      false,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       saveForm(context);
                  //     },
                  //     child: const Text("Submit"),
                  //     style: ElevatedButton.styleFrom(
                  //         primary: themeColor,
                  //         fixedSize: const Size(160, 50),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(50))),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      saveForm(context);
                    },
                    child: const PrimaryButton(
                      buttonText: 'Submit',
                      buttonColor: themeColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hintText, bool isAge,
      bool isHeight, bool isWeight) {
    return Material(
      elevation: 2,
      shape: const StadiumBorder(),
      clipBehavior: Clip.hardEdge,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: themeColor),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(textColor1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(textColor1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: themeColor,
          ),
          errorStyle: const TextStyle(color: Colors.red),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
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
}
