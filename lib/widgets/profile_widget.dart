import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final Future<String?> imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Stack(
          children: [
            buildImage(),
            Positioned(bottom: 0, right: 4, child: buildEditIcon(themeColor)),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return FutureBuilder<String?>(
      future: imagePath,
      builder: (_, snaphsot) {
        if (snaphsot.connectionState == ConnectionState.waiting) {
          return ClipOval(
            child: Material(
              elevation: 4,
              color: Colors.grey[700],
              child: Container(
                width: 128,
                height: 128,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        }
        return ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(snaphsot.data!),
              fit: BoxFit.cover,
              width: 128,
              height: 128,
              child: InkWell(
                onTap: onClicked,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add_a_photo,
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
