import 'package:fitlah/screens/auth/login_signup_screen.dart';
import 'package:fitlah/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/theme_colors.dart';
import '../../widgets/primary_button_widget.dart';

class DeleteProfile extends StatefulWidget {
  const DeleteProfile({Key? key}) : super(key: key);

  @override
  State<DeleteProfile> createState() => _DeleteProfileState();
}

class _DeleteProfileState extends State<DeleteProfile> {
  String _password = "";
  var form = GlobalKey<FormState>();

  delete() async {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      try {
        print(_password);
        AuthService authService = AuthService();
        await authService.login(authService.getCurrentUser()!.email!, _password);
        bool deleteImageResults =
            await UserService.instance().deleteUserImage();
        bool deleteUserResults = await UserService.instance().deleteUser();

        if (!deleteUserResults || !deleteImageResults) {
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Unknown Error has occured '),
            ),
          );
        }
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginSignupScreen(),
          ),
        );
      } catch (e) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Wrong password has been given. Unable to delete account'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: themeColor, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Fitlah',
          style: TextStyle(color: themeColor),
        ),
      ),
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 200,
            ),
            Text(
              'Are you sure you want to delete your account?',
              style: titleText,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'You will lose all data related to this account!',
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: form,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: kTextFieldColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please enter your password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                delete();
              },
              child: const PrimaryButton(
                buttonText: 'Delete Account',
                buttonColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
