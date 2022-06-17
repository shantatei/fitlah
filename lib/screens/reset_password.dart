import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? email;
  var form = GlobalKey<FormState>();

  reset() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      AuthService authService = AuthService();
      return authService.forgotPassword(email).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please check your email for to reset your password!'),
        ));
        Navigator.of(context).pop();
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitlah'),
      ),
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
            ),
            Text(
              'Reset Password',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Please enter your email address',
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: form,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: kTextFieldColor),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor))),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null)
                      return "Please provide an email address.";
                    else if (!value.contains('@'))
                      return "Please provide a valid email address.";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () {
                  reset();
                },
                child: PrimaryButton(buttonText: 'Reset Password'))
          ],
        ),
      ),
    );
  }
}


