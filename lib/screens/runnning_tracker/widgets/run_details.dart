// import 'package:flutter/material.dart';

// import '../../../models/run.dart';

// class RunDetails extends StatelessWidget {
//   final AsyncSnapshot<List<Run>> snapshot;
//   const RunDetails({
//     Key? key,
//     required this.snapshot,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(snapshot.date, style: GoogleFonts.montserrat(fontSize: 18)),
//                   Text((entry.distance / 1000).toStringAsFixed(2) + " km",
//                       style: GoogleFonts.montserrat(fontSize: 18)),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(entry.duration,
//                       style: GoogleFonts.montserrat(fontSize: 14)),
//                   Text(entry.speed.toStringAsFixed(2) + " km/h",
//                       style: GoogleFonts.montserrat(fontSize: 14)),
//                 ],
//               )
//             ],
//           )),
//     );
//   }
// }
