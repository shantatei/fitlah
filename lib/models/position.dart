import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Position {
  String? polylineId;
  double latitude;
  double longitude;
  double speed;
  int timeReached;

  Position._({
    this.polylineId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.timeReached,
  });

  Position.fromMap(Map<String, dynamic> doc, String polylineId)
      : this._(
          polylineId: polylineId,
          latitude: doc["latitude"],
          longitude: doc["longitude"],
          speed: doc["speed"],
          timeReached: doc["timeReached"],
        );

  Position.fromLocationData(LocationData locationData)
      : this._(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          speed: locationData.speed!,
          timeReached: DateTime.now().millisecondsSinceEpoch,
        );

  LatLng toLatLng() => LatLng(latitude, longitude);

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'timeReached': timeReached,
      };

  @override
  String toString() => "{\n"
      "\t'polylineId': '$polylineId',\n"
      "\t'latitude': $latitude,\n"
      "\t'longitude': $longitude,\n"
      "\t'speed': $speed,\n"
      "\t'timeReachedPositionInMilliseconds': $timeReached,\n"
      "}";
}
