import 'dart:math';
import 'dart:typed_data';

import 'package:fitlah/models/run.dart';
import 'package:fitlah/screens/runnning_tracker/all_runs.dart';
import 'package:fitlah/services/position_service.dart';
import 'package:fitlah/services/run_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../models/position.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> {
  final Set<Polyline> _polylines = {};
  GoogleMapController? _controller;

  void setPolylines(List<List<LatLng>> runRoute) {
    setState(() {
      _polylines.clear();
      for (var individualRoute in runRoute) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId(const Uuid().v4()),
            visible: true,
            points: individualRoute,
            width: 3,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            color: themeColor,
          ),
        );
      }
    });
  }

  void animateCamera(LatLng position) {
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 18.5,
        ),
      ),
    );
  }

  void saveRun(Run runModel, List<List<Position>> runRoute) async {
    _setLatLngBounds(
      runRoute.map((polyline) {
        return polyline.map((position) => position.toLatLng()).toList();
      }).toList(),
    );
    Uint8List? runImage = await _takeMapSnapshot();
    Uuid uuid = const Uuid();
    runModel.id = uuid.v4();
    for (List<Position> positionList in runRoute) {
      String polylineId = uuid.v4();
      for (Position position in positionList) {
        position.polylineId = polylineId;
      }
    }
    bool insertResults = await RunService.instance().addRun(
      runModel,
      runImage!,
    );
    bool insertrouteResult = await PositionService.instance().addRunRoute(
      runRoute,
      runModel.id,
    );
    if (!insertResults || !insertrouteResult) {
      print("Error");
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AllRuns(),
      ),
    );
  }

  void _setLatLngBounds(List<List<LatLng>> runRoute) {
    double south = runRoute[0][0].latitude;
    double north = runRoute[0][0].latitude;
    double east = runRoute[0][0].longitude;
    double west = runRoute[0][0].longitude;
    for (List<LatLng> list in runRoute) {
      for (LatLng latLng in list) {
        south = min(south, latLng.latitude);
        north = max(north, latLng.latitude);
        west = min(west, latLng.longitude);
        east = max(east, latLng.longitude);
      }
    }
    LatLngBounds latLngBounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
    _controller?.moveCamera(
      CameraUpdate.newLatLngBounds(
        latLngBounds,
        MediaQuery.of(context).size.width * 0.05,
      ),
    );
  }

  Future<Uint8List?> _takeMapSnapshot() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return _controller?.takeSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(1.3521, 103.8198),
        zoom: 10.0,
      ),
      polylines: _polylines,
      zoomControlsEnabled: false,
      onMapCreated: (googleMapController) {
        _controller = googleMapController;
      },
    );
  }
}
