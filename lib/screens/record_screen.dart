import 'dart:async';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Record extends StatefulWidget {
  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.372440, 103.949550),
    zoom: 11.5,
  );

  Completer<GoogleMapController> _googleMapController = Completer();

  static final Marker _initialMarker = Marker(
    markerId: MarkerId('_initialMarker'),
    infoWindow: InfoWindow(title: 'Current Locaiton'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(1.372440, 103.949550),
  );

  static final Marker _destinationMarker = Marker(
    markerId: MarkerId('_destinationMarker'),
    infoWindow: InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(1.3452, 103.9326),
  );

  static final Polyline _kPolyline = Polyline(
      polylineId: PolylineId('_kPolyline'),
      points: [
        LatLng(1.372440, 103.949550), //Current Location
        LatLng(1.3452, 103.9326) //Destination
      ],
      width: 2);

  static final Polygon _kPolygon = Polygon(
      polygonId: PolygonId('_kPolygon'),
      points: [
        LatLng(1.372440, 103.949550), //Current Location
        LatLng(1.3452, 103.9326), //Destination
        LatLng(1.3453, 103.9226),
        LatLng(1.3454, 103.9226)
      ],
      strokeWidth: 2,
      fillColor: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                height: 350,
                width: 350,
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  polylines: {
                    _kPolyline,
                  },
                  // polygons: {_kPolygon},
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController.complete(controller);
                  },
                  markers: {_initialMarker, _destinationMarker},
                ),
              ),
              Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "00:00",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 30),
                        ),
                        Text(
                          "0KM",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 30),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Duration",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "Distance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "00:00",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 30),
                        ),
                        Text(
                          "0KCAL",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 30),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "PACE(KM/H)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "CALORIES",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: FloatingActionButton(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      startRecord();
                    },
                    child: Text("START")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  startRecord() {
    print("Recording has started");
  }
}
