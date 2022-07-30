import 'package:fitlah/screens/runnning_tracker/widgets/run_detail.dart';
import 'package:fitlah/services/position_service.dart';
import 'package:fitlah/services/run_service.dart';
import 'package:fitlah/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../../../models/run.dart';

class RunList extends StatefulWidget {
  final List<Run>? runList;
  final bool isLoading;
  final void Function(bool) setLoading;
  const RunList({
    required Key? key,
    required this.runList,
    required this.isLoading,
    required this.setLoading,
  }) : super(key: key);

  @override
  State<RunList> createState() => RunListState();
}

class RunListState extends State<RunList> {
  List<GlobalKey<RunDetailState>> allListItems = [];
  bool isSelectable = false;

  List<String> get selectedItems {
    List<String> selected = [];
    for (GlobalKey<RunDetailState> listItem in allListItems) {
      if (listItem.currentState?.isSelected == true) {
        selected.add(
          listItem.currentState!.widget.runModel.id,
        );
      }
    }
    return selected;
  }

  int get selectedCount {
    return selectedItems.length;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = widget.isLoading
        ? List.filled(5, const CircularProgressIndicator())
        : widget.runList!.map((Run runModel) {
            GlobalKey<RunDetailState> listItemKey = GlobalKey();
            allListItems.add(listItemKey);
            return FutureBuilder<String>(
              future:
                  StorageService.instance().getDownloadUrl(runModel.runImage),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return RunDetail(
                  key: listItemKey,
                  parentKey: widget.key as GlobalKey<RunListState>,
                  runModel: runModel,
                  imageUrl: snapshot.data!,
                  isSelectable: isSelectable,
                  onDeleteTap: () async {
                    widget.setLoading(true);
                    await RunService.instance().deleteRun([
                      runModel.id,
                    ]);
                    await PositionService.instance().deleteRunRoute(
                      runModel.id,
                    );
                    widget.setLoading(false);
                  },
                );
              },
            );
          }).toList();

    return SingleChildScrollView(
      physics: widget.isLoading
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      child: Column(
        children: children,
      ),
    );
  }
}
