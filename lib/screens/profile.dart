import 'package:fitlah/screens/edit_profile.dart';
import 'package:fitlah/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ProfileWidget(
          //use user imagepath ltr*
          imagePath:
              'https://media.istockphoto.com/photos/portrait-of-a-handsome-black-man-picture-id1289461335?b=1&k=20&m=1289461335&s=170667a&w=0&h=7L30Sh0R-0JXjgqFnxupL9msH5idzcz0xZUAMB9hY_k=',
          onClicked: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => EditProfile()));
          },
        ),
        const SizedBox(height: 24),
        buildInfo("55kg", "26 y.o", "165cm"),
      ],
    );
  }

  Widget buildInfo(String weight, String age, String height) {
    return Center(
      child: Column(
        children: [
          Text(
              //use user fullname later *
              "Robert",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Weight",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                Text("Age",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                Text("Height",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(weight,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(age,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(height,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
