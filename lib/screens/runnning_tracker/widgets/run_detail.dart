import 'package:fitlah/screens/runnning_tracker/widgets/run_list.dart';
import 'package:fitlah/utils/extensions.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../models/run.dart';

class RunDetail extends StatefulWidget {
  final GlobalKey<RunListState> parentKey;
  final Run runModel;
  final bool isSelectable;
  final String imageUrl;
  final void Function() onDeleteTap;

  const RunDetail({
    required Key? key,
    required this.parentKey,
    required this.runModel,
    required this.imageUrl,
    required this.isSelectable,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  State<RunDetail> createState() => RunDetailState();
}

class RunDetailState extends State<RunDetail> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        child: Slidable(
          key: ValueKey(widget.runModel.id),
          endActionPane:
              widget.isSelectable ? null : _getActionPanel(widget.runModel),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Material(
                  key: globalKey,
                  elevation: 10,
                  child: Column(
                    children: [
                      SizedBox(
                        child: _getImage(widget.runModel),
                      ),
                      _getDetailsRow(widget.runModel),
                    ],
                  ),
                ),
                _getOverlay(widget.runModel.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ActionPane _getActionPanel(Run runModel) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        onDismissed: () {
          widget.onDeleteTap();
        },
      ),
      children: [
        SlidableAction(
          onPressed: (_) {
            widget.onDeleteTap();
          },
          icon: Icons.delete,
          label: 'Delete run',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        )
      ],
    );
  }

  Widget _getImage(Run runModel) {
    return Hero(
      tag: 'image-${runModel.id}',
      child: Image.network(
        widget.imageUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container();
        },
      ),
    );
  }

  Widget _getDetailsRow(Run runModel) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _getValue(
            context,
            (runModel.distance > 1000
                    ? runModel.distance / 1000
                    : runModel.distance.toInt())
                .toString(),
            runModel.distance > 1000 ? 'km' : 'm',
          ),
          _getValue(
            context,
            runModel.duration.toTimeString(),
            'Time',
          ),
          _getValue(
            context,
            runModel.speed.toStringAsFixed(2),
            'km/h',
          ),
        ],
      ),
    );
  }

  Widget _getValue(BuildContext context, String value, String unit) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
          ),
          Text(
            unit,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }

  Widget _getOverlay(String id) {
    return Visibility(
      visible: isSelected,
      child: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).focusColor,
        child: const Icon(
          Icons.check_box,
          color: themeColor,
          size: 50,
        ),
      ),
    );
  }
}
