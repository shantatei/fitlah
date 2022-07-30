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
      appBar: AppBar(
        title: const Text("Your Runs"),
      ),
      body: StreamBuilder<List<Run>>(
        stream: RunService.instance().getRunList(),
        builder: _builder,
        // builder: (context, snapshot) {
        //   bool snapshotIsWaiting =
        //       snapshot.connectionState == ConnectionState.waiting;
        //   if (!snapshotIsWaiting &&
        //       (!snapshot.hasData || snapshot.data!.isEmpty)) {
        //     return const Text("You have no runs saved yet ! ");
        //   }
        //   return ListView();
        // },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
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
      return const Text("You have no runs saved yet ! ");
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

  // void deleteRuns() async {
  //   if (_listViewKey.currentState?.selectedCount == 0) return clearSelection();
  //   setState(() {
  //     isSelectable = false;
  //     isLoading = true;
  //     title = null;
  //   });
  //   _listViewKey.currentState!.setState(() {
  //     _listViewKey.currentState!.isSelectable = false;
  //   });
  //   widget.appbarKey.currentState?.setTitle("Your Runs");
  //   widget.refreshParent();
  //   List<String> selectedItems = _listViewKey.currentState!.selectedItems;
  //   bool deleteResults = await RunRepository.instance().deleteRun(
  //     selectedItems,
  //   );
  //   bool isPositionDeleted = false;
  //   for (String runId in selectedItems) {
  //     isPositionDeleted = await PositionRepository.instance().deleteRunRoute(
  //       runId,
  //     );
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  //   if (!deleteResults || !isPositionDeleted) {
  //     SnackbarUtils(context: context).createSnackbar(
  //       'Unknown error has occurred',
  //     );
  //   }
  // }

}
