import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/primary_button_widget.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
              'Reset Password',
              style: titleText,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Please enter your email address',
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
                      hintText: 'Email',
                      hintStyle: TextStyle(color: kTextFieldColor),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor))),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) {
                      return "Please provide an email address.";
                    } else if (!value.contains('@')) {
                      return "Please provide a valid email address.";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                reset();
              },
              child: const PrimaryButton(
                buttonText: 'Reset Password',
                buttonColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
