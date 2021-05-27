import 'package:location/location.dart';

class UserCurrentLocation {
  Location _location;
  UserCurrentLocation() {
    _location = new Location();
  }

  Future<bool> _isServiceEnabled() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (onError) {
      throw onError.toString();
    }
  }

  Future<bool> _isPermissionGranted() async {
    try {
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (onError) {
      throw onError.toString();
    }
  }

  Future<LocationData> getUserLocation() async {
    bool isServiceEnabled = await _isServiceEnabled();
    if (isServiceEnabled) {
      bool isPermissionGranted = await _isPermissionGranted();
      if (isPermissionGranted) {
        return await _location.getLocation();
      } else {
        throw 'Something went wrong';
      }
    }
  }
}
