import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? email;
  String? fullName;
  var form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitlah"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath:
                'https://media.istockphoto.com/photos/portrait-of-a-handsome-black-man-picture-id1289461335?b=1&k=20&m=1289461335&s=170667a&w=0&h=7L30Sh0R-0JXjgqFnxupL9msH5idzcz0xZUAMB9hY_k=',
            isEdit: true,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          editProfileForm()
        ],
      ),
    );
  }

  Widget editProfileForm() {
    return Form(
      key: form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'FullName',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        buildTextField('Robert', false),
        Text(
          'Email',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        buildTextField('teirenxuanshanta@gmail.com', true),
        ElevatedButton(onPressed: editSave, child: Text("Save"))
      ]),
    );
  }

  Widget buildTextField(String initialText, bool isEmail) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialText,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
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
          if (isEmail) {
            if (value == null || value.isEmpty) {
              return "Please enter an email address ";
            } else if (!value.contains('@'))
              return "Please provide a valid email address.";
            else
              return null;
          } else {
            if (value == null || value.isEmpty) {
              return "Please your FullName";
            } else
              return null;
          }
        },
        onSaved: (value) {
          if (isEmail) {
            email = value;
          } else {
            fullName = value;
          }
        },
      ),
    );
  }

  editSave() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
    }
  }
}
