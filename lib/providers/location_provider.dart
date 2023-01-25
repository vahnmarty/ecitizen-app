import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  String lat = '';
  String lng = '';
  String address = '';


  getCurrentLocation() async {
    var locationData = await gettingLoc();
    if (locationData != null) {
      lat = locationData.latitude.toString();
      lng = locationData.longitude.toString();
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            locationData.latitude!, locationData.longitude!);
        if (placemarks.length > 0) {
          Placemark place = placemarks[0];
          //debugPrint('location: ${place.toString()}');

          address =
              "${place.street} ${place.locality} ${place.subAdministrativeArea} ${place.country} ${place.postalCode}";
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    notifyListeners();
  }

  Future<loc.LocationData?> gettingLoc() async {
    try {
      loc.Location location = new loc.Location();

      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;
      loc.LocationData _locationData;
      print("inlocation function");

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        print("inlocation function2");
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          debugPrint('Location not Enabled!');
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      print("inlocation function3");
      if (_permissionGranted == loc.PermissionStatus.denied) {
        debugPrint('Permission Granted!');
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          debugPrint('Permission not granted!');
          return null;
        }
      }
      if (_permissionGranted == loc.PermissionStatus.denied) {
        debugPrint('Permission Denied!');
        return null;
      }
      print("inlocation function4");

      _locationData = await location.getLocation();
      print(_locationData);
      print("inlocation function5");
      return _locationData;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
