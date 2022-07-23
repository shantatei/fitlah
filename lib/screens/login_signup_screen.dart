import 'package:fitlah/screens/reset_password_screen.dart';
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
  String? username;
  String? password;
  String? confirmPassword;

  AuthService authService = AuthService();
  var form = GlobalKey<FormState>();
  bool isMale = true;
  bool isSignupScreen = true;
  bool isRememberMe = false;

  register() async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('User Registered successfully!'),
          ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Login successfully!'),
        ));
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
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(backgroundColor: Colors.red, content: Text('Login Failed')));
      // }
    }
  }

  void _resetForm() {
    form.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(backgroundColor),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
                color: Colors.transparent.withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: TextStyle(
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
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              top: isSignupScreen ? 310 : 340,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                height: isSignupScreen ? 380 : 290,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
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
                                          ? Color(textColor1)
                                          : Color(activeColor)),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
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
                                          ? Color(activeColor)
                                          : Color(textColor1)),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
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
      margin: EdgeInsets.only(top: 20),
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
                  child: Text(
                    "Forget Password",
                    style: TextStyle(fontSize: 12, color: Color(textColor1)),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Form(
        key: form,
        child: Column(children: [
          // buildTextField(Icons.person, "Username", false, false, false),
          buildTextField(Icons.email, "Email", false, true, false),
          buildTextField(Icons.lock, "Password", true, false, false),
          buildTextField(Icons.lock, "Confirm Password", false, false, true),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              isMale ? Color(textColor2) : Colors.transparent,
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Colors.transparent
                                  : Color(textColor1)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.person,
                          color: isMale ? Colors.white : Color(iconColor),
                        ),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(color: Color(textColor1)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              isMale ? Colors.transparent : Color(textColor2),
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Color(textColor1)
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.person,
                          color: isMale ? Color(iconColor) : Colors.white,
                        ),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(color: Color(textColor1)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container()
        ]),
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 700),
        curve: Curves.bounceInOut,
        top: isSignupScreen ? 645 : 580,
        right: 0,
        left: 0,
        child: Center(
          child: Container(
            height: 90,
            width: 90,
            padding: EdgeInsets.all(15),
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
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.red],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1))
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
                : Center(),
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
      child: TextFormField(
        obscureText: isPassword || isConfirmPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Color(iconColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(textColor1)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(textColor1)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Color(textColor1)),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(35.0))),
        ),
        validator: (value) {
          if (isPassword) {
            if (value == null || value.isEmpty) {
              return "Please provide a password ";
            } else if (value.length < 6)
              return 'Password must be at least 6 characters.';
            else
              return null;
          } else if (isEmail) {
            if (value == null || value.isEmpty) {
              return "Please enter an email address ";
            } else if (!value.contains('@'))
              return "Please provide a valid email address.";
            else
              return null;
          } else if (isConfirmPassword) {
            if (value == null || value.isEmpty) {
              return "Please provide a password ";
            } else if (value.length < 6)
              return 'Password must be at least 6 characters.';
            else
              return null;
          } else {
            if (value == null || value.isEmpty) {
              return "Please enter your username";
            } else if (value.length < 6)
              return 'Username must be at least 6 characters';
            else
              return null;
          }
        },
        onSaved: (value) {
          if (isPassword) {
            password = value;
          } else if (isEmail) {
            email = value;
          } else if (isConfirmPassword) {
            confirmPassword = value;
          } else {
            username = value;
          }
        },
      ),
    );
  }
}
