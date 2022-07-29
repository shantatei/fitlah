import 'package:fitlah/screens/runnning_tracker/run_tracker_screen.dart';
import 'package:fitlah/services/run_service.dart';
import 'package:flutter/material.dart';

import '../../models/run.dart';

class AllRuns extends StatefulWidget {
  const AllRuns({Key? key}) : super(key: key);

  @override
  State<AllRuns> createState() => _AllRunsState();
}

class _AllRunsState extends State<AllRuns> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Runs"),
      ),
      body: StreamBuilder<List<Run>>(
          stream: RunService.instance().getRunList(),
          builder: (context, snapshot) {
            bool snapshotIsWaiting =
                snapshot.connectionState == ConnectionState.waiting;
            if (!snapshotIsWaiting &&
                (!snapshot.hasData || snapshot.data!.isEmpty)) {
              return const Text("You have no runs saved yet ! ");
            }
            return ListView(
              
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RunTracker(),
          ),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        // .then((value) => _addEntries(value),),
      ),
    );
  }
}
