import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  var form = GlobalKey<FormState>();
  bool isMale = true;
  bool isSignupScreen = true;
  bool isRememberMe = false;

  checkFormValid() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      return true;
    }
    return false;
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
                color: Color(0xFF3b5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.yellow[700],
                          ),
                          children: [
                            TextSpan(
                              text: "Fitlah",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
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
              top: isSignupScreen ? 200 : 230,
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
            buildTextField(Icons.email, "example@gmail.com", false, true),
            buildTextField(Icons.lock, "*********", true, false),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {},
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
          buildTextField(Icons.person, "Username", false, false),
          buildTextField(Icons.email, "Email", false, true),
          buildTextField(Icons.lock, "Password", true, false),
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
        top: isSignupScreen ? 535 : 470,
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
                        if (checkFormValid()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Validated Successfully'),
                          ));
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
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        obscureText: isPassword,
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
          if (value == null || value.isEmpty) {
            return "Please enter a key ";
          }
          return null;
        },
      ),
    );
  }
}
