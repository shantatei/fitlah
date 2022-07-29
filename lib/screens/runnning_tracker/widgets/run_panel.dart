import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';

class RunPanel extends StatefulWidget {
  const RunPanel({Key? key}) : super(key: key);

  @override
  State<RunPanel> createState() => RunPanelState();
}

class RunPanelState extends State<RunPanel> {
  double distance = 0.0;
  String duration = "00:00:00";
  final bool _isTracking = false;
   void handleclick = ({});

  void setDistance(double distanceRan) {
    setState(() {
      distance = distanceRan;
    });
  }

  void setDuration(String timeTaken) {
    setState(() {
      duration = timeTaken;
    });
  }

  void setHandleClick(void handleClick) {
    setState(() {
      handleclick = handleClick;
    });
  }

  String _getDistanceString() {
    if (distance < 1200) {
      return "${distance.toInt()}m";
    }
    return "${(distance / 1200).toStringAsFixed(3)}km";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: const [
            Text("SPEED (KM/H)",
                style:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
            Text("0:00",
                style:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.w300))
          ],
        ),
        Column(
          children: [
            const Text(
              "Time",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            Text(
              duration,
              style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              "DISTANCE (KM)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            Text(
              _getDistanceString(),
              style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w300),
            )
          ],
        ),
      ],
    );
  }
}
