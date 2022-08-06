import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitlah/models/goals.dart';
import 'package:fitlah/screens/profile/edit_profile_screen.dart';
import 'package:fitlah/services/goals_service.dart';
import 'package:fitlah/services/user_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var form = GlobalKey<FormState>();

  int? waterintake;

  int? caloriesintake;

  int? steps;

  UserModel? _userModel;
  String? username = "";
  double? height = 0.0;
  double? weight = 0.0;
  int? age = 0;

  Future<String?> getProfileImage(String imagePath) async {
    return await FirebaseStorage.instance
        .ref()
        .child(imagePath)
        .getDownloadURL();
  }

  void _editGoals(List<Goals> goals, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Calores Goal '),
            content: Form(
              key: form,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: goals.first.caloriesintake.toString(),
                    decoration: const InputDecoration(
                      labelText: "Calories Goal (kcal)",
                      hintText: "Please enter your Calories Intake Goal",
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Calories Intake  Goal";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value == null) return;
                      caloriesintake = int.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: goals.first.waterintake.toString(),
                    decoration: const InputDecoration(
                      labelText: "Water Intake Goal (ml)",
                      hintText: "Please enter your Water Intake Goal",
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Water Intake Goal";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value == null) return;
                      waterintake = int.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: goals.first.steps.toString(),
                    decoration: const InputDecoration(
                      labelText: "Steps (m)",
                      hintText: "Please enter your Steps Goal",
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Steps Goal";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value == null) return;
                      steps = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context), // passing false
                child: const Text('Cancel'),
              ),
              FlatButton(
                  onPressed: () {
                    bool isValid = form.currentState!.validate();
                    if (isValid) {
                      form.currentState!.save();

                      GoalService.instance().updateGoal(
                        goals.first.id,
                        waterintake,
                        caloriesintake,
                        steps,
                      );

                      // Hide the keyboard
                      FocusScope.of(context).unfocus();
                      // Resets the form
                      form.currentState!.reset();

                      //Exiting Form
                      Navigator.of(context).pop();

                      // Shows a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Goals Updated Successfully!'),
                      ));
                    }
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Goals>>(
      stream: GoalService.instance().getGoal(),
      builder: (context, snapshot) {
        return StreamBuilder<UserModel?>(
          stream: UserService.instance().getUserStream(),
          builder: (context, user) {
            if (user.connectionState == ConnectionState.waiting ||
                !user.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (user.hasData) {
              _userModel = user.data;
              username = _userModel?.username;
              weight = _userModel?.weight;
              height = _userModel?.height;
              age = _userModel?.age;
            }
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                user.data?.profileImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Stack(
                            children: [
                              ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image:
                                        NetworkImage(user.data!.profileImage!),
                                    fit: BoxFit.cover,
                                    width: 128,
                                    height: 128,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EditProfile(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: buildEditIcon(themeColor),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ProfileWidget(
                        imagePath: getProfileImage("user.png"),
                        onClicked: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 24),
                buildInfo(
                    weight!.toString(), age!.toString(), height!.toString()),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 250,
                    height: 270,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: Colors.black,
                        )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Goals",
                                style: CustomTextStyle.metricTextStyle2,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _editGoals(
                                    snapshot.hasData ? snapshot.data! : [],
                                    context,
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        ListTile(
                          leading: const FaIcon(
                            FontAwesomeIcons.bolt,
                            color: Colors.orange,
                          ),
                          title: const Text(
                            "Calories",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                          subtitle: Text(
                            snapshot.hasData && snapshot.data!.isNotEmpty
                                ? snapshot.data!.first.caloriesintake.toString()
                                : "2000",
                            style: CustomTextStyle.metricTextStyle2,
                          ),
                        ),
                        ListTile(
                          leading: const FaIcon(
                            FontAwesomeIcons.droplet,
                            color: themeColor,
                          ),
                          title: const Text(
                            "Water",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                          subtitle: Text(
                            snapshot.hasData && snapshot.data!.isNotEmpty
                                ? snapshot.data!.first.waterintake.toString()
                                : "2000",
                            style: CustomTextStyle.metricTextStyle2,
                          ),
                        ),
                        ListTile(
                          leading: const FaIcon(
                            FontAwesomeIcons.shoePrints,
                            color: Colors.red,
                          ),
                          title: const Text(
                            "Steps",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                          subtitle: Text(
                            snapshot.hasData && snapshot.data!.isNotEmpty
                                ? snapshot.data!.first.steps.toString()
                                : "10000",
                            style: CustomTextStyle.metricTextStyle2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget buildInfo(String weight, String age, String height) {
    return Center(
      child: Column(
        children: [
          Text(
            username!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          // ElevatedButton(
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const DeleteProfile(),
          //     ),
          //   ),
          //   child: const Text("Delete Account"),
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.red,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
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
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(weight,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(age,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(height,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
