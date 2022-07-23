import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  var form = GlobalKey<FormState>();

  String username = "";
  saveForm() async {
    if (!form.currentState!.validate()) return;

    form.currentState!.save();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthService().getCurrentUser()!.email!)
        .set({"username": username});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: form,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(iconColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(textColor1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(textColor1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Username",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(textColor1),
                    ),
                    errorStyle: TextStyle(color: Colors.red),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    saveForm();
                  },
                  child: const Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
