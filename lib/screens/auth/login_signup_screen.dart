import 'package:fitlah/screens/auth/reset_password_screen.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  static String routeName = '/auth';
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  String? email;
  String? password;
  String? confirmPassword;

  AuthService authService = AuthService();
  var form = GlobalKey<FormState>();
  bool isSignupScreen = true;
  bool isRememberMe = false;

  register() async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Password and Confirm Password does not match!'),
        ));
      } else {
        AuthService authService = AuthService();
        try {
          var value = await authService.register(email, password);
          authService.logOut();
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('User Registered successfully!'),
          ));
          _resetForm();
        } catch (error) {
          FocusScope.of(context).unfocus();
          String message = error.toString().contains('] ')
              ? error.toString().split('] ')[1]
              : 'An error has occurred.';
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      }
    }
  }

  login() async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      AuthService authService = AuthService();
      try {
        var value = await authService.login(email, password);
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Login successfully!'),
          ),
        );
      } catch (error) {
        FocusScope.of(context).unfocus();
        String message = error.toString().contains('] ')
            ? error.toString().split('] ')[1]
            : 'An error has occurred.';
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ));
      }
    }
  }

  void _resetForm() {
    form.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: const EdgeInsets.only(top: 90, left: 20),
                color: const Color.fromARGB(0, 72, 68, 68).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: "Fitlah",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: const TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //Trick to add the shadow for the submit button
          buildBottomHalfContainer(true),
          //Main Container for Login and Signup
          AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              top: isSignupScreen ? 310 : 340,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                height: isSignupScreen ? 310 : 290,
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                              _resetForm();
                            },
                            child: Column(
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? const Color(textColor1)
                                          : const Color(activeColor)),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: themeColor,
                                  )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                                _resetForm();
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "SIGNUP",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? const Color(activeColor)
                                          : const Color(textColor1)),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: themeColor,
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                      if (isSignupScreen) buildSignupSection(),
                      if (!isSignupScreen) buildSigninSection()
                    ],
                  ),
                ),
              )),
          //Trick to add the submit button
          buildBottomHalfContainer(false),
          //Add Social Buttons Below here (if thr's time)
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        key: form,
        child: Column(
          children: [
            buildTextField(
                Icons.email, "example@gmail.com", false, true, false),
            buildTextField(Icons.lock, "*********", true, false, false),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ResetPasswordScreen.routeName);
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(fontSize: 12, color: Color(textColor1)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        key: form,
        child: Column(
          children: [
            // buildTextField(Icons.person, "Username", false, false, false),
            buildTextField(Icons.email, "Email", false, true, false),
            buildTextField(Icons.lock, "Password", true, false, false),
            buildTextField(Icons.lock, "Confirm Password", false, false, true),
            Container()
          ],
        ),
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 700),
        curve: Curves.bounceInOut,
        top: isSignupScreen ? 575 : 580,
        right: 0,
        left: 0,
        child: Center(
          child: Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if (showShadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                    )
                ]),
            child: !showShadow
                ? Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [themeColor, Colors.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1))
                        ]),
                    child: IconButton(
                      onPressed: () {
                        if (isSignupScreen) {
                          register();
                        } else {
                          login();
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      color: Colors.white,
                    ),
                  )
                : const Center(),
          ),
        ));
  }

  Widget buildTextField(
    IconData icon,
    String hintText,
    bool isPassword,
    bool isEmail,
    bool isConfirmPassword,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        elevation: 2,
        shape: const StadiumBorder(),
        clipBehavior: Clip.hardEdge,
        child: TextFormField(
          obscureText: isPassword || isConfirmPassword,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: themeColor,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(textColor1)),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(textColor1)),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            contentPadding: const EdgeInsets.all(10),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14, color: themeColor),
            errorStyle: const TextStyle(color: Colors.red),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(35.0))),
          ),
          validator: (value) {
            if (isPassword) {
              if (value == null || value.isEmpty) {
                return "Please provide a password ";
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters.';
              } else {
                return null;
              }
            } else if (isEmail) {
              if (value == null || value.isEmpty) {
                return "Please enter an email address ";
              } else if (!value.contains('@')) {
                return "Please provide a valid email address.";
              } else {
                return null;
              }
            } else if (isConfirmPassword) {
              if (value == null || value.isEmpty) {
                return "Please provide a password ";
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters.';
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
            if (isPassword) {
              password = value;
            } else if (isEmail) {
              email = value;
            } else if (isConfirmPassword) {
              confirmPassword = value;
            }
          },
        ),
      ),
    );
  }
}
