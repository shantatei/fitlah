import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const CARBS_COLOR = 0xffD83027;
const PROTEIN_COLOR = 0x9027D830;
const FAT_COLOR = 0xFF0D47A1;
const iconColor = 0xFFB6C7D1;
const activeColor = 0xFF09126C;
const textColor1 = 0XFFA7BCC7;
const textColor2 = 0XFF9BB3C0;
const backgroundColor = 0xFFECF3F9;
const kPrimaryColor = Color(0xFF1B383A);
const kSecondaryColor = Color(0xFF59706F);
const kDarkGreyColor = Color(0xFFA8A8A8);
const kWhiteColor = Color(0xFFFFFFFF);
const kZambeziColor = Color(0xFF5B5B5B);
const kBlackColor = Color(0xFF272726);
const kLightColor = Color(0xffc4bbcc);
const kTextFieldColor = Color(0xFF979797);
const kBackgroundColor = Color(0xffF3F3F3);
const themeColor = Color.fromARGB(255, 15, 3, 226);

const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);

TextStyle titleText =
    TextStyle(color: kPrimaryColor, fontSize: 32, fontWeight: FontWeight.w700);
TextStyle subTitle = TextStyle(
    color: kSecondaryColor, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle textButton = TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class CustomTextStyle {
  static const dayTabBarStyleInactive = TextStyle(
    color: kTextFieldColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const dayTabBarStyleActive = TextStyle(
    color: themeColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  static const metricTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  static const metricTextStyle2 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}
