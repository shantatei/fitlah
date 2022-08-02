import 'package:fitlah/screens/runnning_tracker/run_tracker_screen.dart';
import 'package:fitlah/screens/runnning_tracker/widgets/run_list.dart';
import 'package:fitlah/services/run_service.dart';
import 'package:flutter/material.dart';

import '../../models/run.dart';

class AllRuns extends StatefulWidget {
  const AllRuns({Key? key}) : super(key: key);

  @override
  State<AllRuns> createState() => _AllRunsState();
}

class _AllRunsState extends State<AllRuns> {
  final GlobalKey<RunListState> _listViewKey = GlobalKey<RunListState>();
  bool isSelectable = false;
  bool isLoading = false;
  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Run>>(
        stream: RunService.instance().getRunList(),
        builder: _builder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RunTracker(),
          ),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _builder(
    BuildContext context,
    AsyncSnapshot<List<Run>> snapshot,
  ) {
    if (isLoading) return Container();
    bool snapshotIsWaiting =
        snapshot.connectionState == ConnectionState.waiting;
    if (!snapshotIsWaiting && (!snapshot.hasData || snapshot.data!.isEmpty)) {
      return const Center(
        child: Text(
          "You have no runs saved yet ! ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: RunList(
        key: _listViewKey,
        runList: snapshot.data,
        isLoading: snapshotIsWaiting,
        setLoading: (bool value) {
          setState(() {
            isLoading = value;
          });
        },
      ),
    );
  }
}
