import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  String lat = '';
  String lng = '';
  String address = '';

  getCurrentLocation() async {
    var locationData = await gettingPosition();
    //debugPrint('location data $locationData');
    if (locationData != null) {
      lat = locationData.latitude.toString();
      lng = locationData.longitude.toString();
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            locationData.latitude, locationData.longitude);
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

  Future<Position?> gettingPosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('error while getting geolocation=> $e');
      return null;
    }
  }
}
