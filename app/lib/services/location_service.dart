// ignore_for_file: unnecessary_string_escapes
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import "package:latlong2/latlong.dart";

import 'logger_service.dart';

class LocationService {
  static final LocationService _service = LocationService._internal();
  final loc.Location _loc = loc.Location();
  bool enableBackground = true;

  Placemark? _currentLocation;
  LatLng? _currentCoordinates;

  factory LocationService() {
    return _service;
  }

  LocationService._internal();

  Future<void> init() async {
    _loc.enableBackgroundMode(enable: enableBackground);
    _loc.changeSettings(
        accuracy: loc.LocationAccuracy.high, interval: 60 * 1000);
    _loc.onLocationChanged.listen((_data) {
      _currentCoordinates = LatLng(_data.latitude!, _data.longitude!);
      _update(_currentCoordinates);
    });
    update();
  }

  Placemark? getCurrentLocation() {
    return _currentLocation;
  }

  LatLng? getCurrentCoordinates() {
    return _currentCoordinates;
  }

  Future<bool> update() async {
    bool hasService = await _update(await _getLocation());
    if (!hasService) {
      // TODO: Get last location from api
      log.severe("Cannot get current location, using last known location");
    }
    // TODO: send  current location to api
    return hasService;
  }

  Future<LatLng?> _getLocation() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await _loc.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _loc.requestService();
      if (!_serviceEnabled) {
        log.warning("Could not enable location service");
        return null;
      }
    }

    _permissionGranted = await _loc.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _loc.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        log.warning("Could not get permission to use location service");
        return null;
      }
    }
    loc.LocationData _data = await _loc.getLocation();
    _currentCoordinates = LatLng(_data.latitude!, _data.longitude!);
    return _currentCoordinates;
  }

  Future<bool> _update(LatLng? location) async {
    if (location == null) {
      log.warning("Could not update location: longitute and latitude not set");
      return false;
    }
    List<Placemark> placemark =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemark.isNotEmpty) {
      _currentLocation = placemark.elementAt(0);
      return true;
    }
    log.warning("No location found for current latitude and longitude");
    return false;
  }
}
