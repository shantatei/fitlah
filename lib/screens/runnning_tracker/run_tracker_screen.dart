import 'dart:async';
import 'package:fitlah/main.dart';
import 'package:fitlah/screens/runnning_tracker/widgets/maps.dart';
import 'package:fitlah/screens/runnning_tracker/widgets/run_panel.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../models/position.dart';
import '../../models/run.dart';
import '../../utils/theme_colors.dart';

class RunTracker extends StatefulWidget {
  const RunTracker({Key? key}) : super(key: key);
  @override
  State<RunTracker> createState() => _RunTrackerState();
}

class _RunTrackerState extends State<RunTracker> {
  final Location _location = Location();
  final List<List<Position>> _runRoute = [];
  bool _permissionGranted = false;
  bool _takingSnapshot = false;
  bool _isTracking = false;
  bool _isFirstTimeTracking = true;
  int timestarted = 0;
  int duration = 0;
  double distance = 0;
  double speed = 0;

  final AuthService authService = AuthService();

  final GlobalKey<MapsState> _mapKey = GlobalKey();
  final GlobalKey<RunPanelState> _runPanelKey = GlobalKey();

  Future<bool> _isLocationEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Your Run"),
        actions: [
          Visibility(
            visible: !_isTracking && !_isFirstTimeTracking,
            child: IconButton(
              onPressed: () => _saveRun(),
              icon: const Icon(Icons.save),
            ),
          ),
          IconButton(
            onPressed: () => _closeRun(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: FutureBuilder<bool>(
        future: _isLocationEnabled(),
        builder: (context, locationIsEnabled) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: _takingSnapshot
                    ? MediaQuery.of(context).size.width / 2
                    : double.infinity,
                child: _handlePermission(
                  locationIsEnabled.hasData && locationIsEnabled.data!,
                ),
              ),
              _takingSnapshot ? _loadingToSaveRun() : _controlPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingToSaveRun() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Material(
        elevation: 10,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Do not close the app',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Your run is being saved',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }

  void _saveRun() async {
    if (_runRoute.isEmpty || _runRoute[0].length < 2 || _takingSnapshot) return;
    setState(() {
      _isTracking = false;
      _takingSnapshot = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    _location.enableBackgroundMode(enable: false);
    double distanceRanInKilometres = distance / 1000;
    double timeTakenInHours = duration / 1000 / 60 / 60;
    Run runModel = Run(
      id: '',
      email: authService.getCurrentUser()!.email.toString(),
      runImage: "maps/dark-${const Uuid().v4()}",
      date: DateFormat.yMMMMd('en_US').format(DateTime.now()),
      timestarted: timestarted,
      duration: duration,
      distance: distance,
      speed: distanceRanInKilometres / timeTakenInHours,
    );
    _mapKey.currentState!.saveRun(runModel, _runRoute);
  }

  void _closeRun(BuildContext context) {
    if (_takingSnapshot) return;
    if (_isFirstTimeTracking) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(index: 1,),
        ),
      );

      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel the run?"),
        content: const Text(
          "Are you sure you want to delete the current run and lose all its data forever?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isTracking = false;
              });
              _location.enableBackgroundMode(enable: false);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScreen(index: 1,),
                ),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _handleClick() {
    setState(() {
      _isTracking = !_isTracking;
      if (_isFirstTimeTracking) {
        _isFirstTimeTracking = false;
        timestarted = DateTime.now().millisecondsSinceEpoch;
      }
      if (!_isTracking) return;
      _startTimer();
      _location.enableBackgroundMode();
      _setUpNotification();
      _runRoute.add([]);
    });
  }

  Widget _controlPanel() {
    if (!_permissionGranted) return Container();

    return Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 40),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            RunPanel(
              key: _runPanelKey,
            ),
            const Divider(),
            FloatingActionButton(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  _handleClick();
                },
                child: Text(_isTracking ? "PAUSE" : "START"))
          ],
        ));
  }

  void _setUpNotification([
    String subtitle = "00:00:00",
  ]) {
    late String distanceRan;
    if (distance < 1000) {
      distanceRan = "${distance.toInt()}m";
    } else {
      distanceRan = "${distance / 1000}km";
    }
    _location.changeNotificationOptions(
      title: 'You have ran $distanceRan, keep it up!',
      iconName: 'ic_shoes',
      subtitle: subtitle,
      onTapBringToFront: true,
    );
  }

  Widget _handlePermission(bool permissionGranted) {
    _permissionGranted = permissionGranted;
    if (!_permissionGranted) {
      return const Text("No Permission has been granted");
    }
    _setLocationListener();
    return Maps(
      key: _mapKey,
    );
  }

  void _setLocationListener() {
    _location.onLocationChanged.distinct().listen((locationData) {
      if (!_isTracking) return;
      _runRoute.last.add(Position.fromLocationData(locationData));
      List<List<LatLng>> polylines = _runRoute.map(
        (polyline) {
          return polyline.map((position) => position.toLatLng()).toList();
        },
      ).toList();
      print(polylines);
      distance = polylines.calculateDistance();
      speed = locationData.speed!;
      _runPanelKey.currentState!.setSpeed(speed);
      _runPanelKey.currentState!.setDistance(distance);
      _mapKey.currentState!.setPolylines(polylines);
      _mapKey.currentState!.animateCamera(polylines.last.last);
    });
  }

  void _startTimer() {
    Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        if (!_isTracking) return timer.cancel();
        duration += 1000;
        double timeTakenInHours = duration / 1000 / 60 / 60;
        var timeTaken = duration.toTimeString();
        _runPanelKey.currentState!.setDuration(timeTaken);
        _setUpNotification(timeTaken);
      },
    );
  }
}
