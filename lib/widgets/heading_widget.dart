import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String text1;
  final String text2;
  const HeadingWidget({required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      // margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            text1,
            style: const TextStyle(
                color: themeColor, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(child: Container()),
          Text(
            text2,
            style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
