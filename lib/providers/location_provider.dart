import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/constancts.dart';

class LocationProvider with ChangeNotifier {
  String lat = '';
  String lng = '';
  String address = '';


  getCurrentLocation(BuildContext context) async {
    var locationData = await gettingPosition(context);
    debugPrint('location data $locationData');
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

  Future<Position?> gettingPosition(BuildContext context) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        showAlertDialog(context, "Service is not enabled",
            "Please enable the location service for better results!",
            type: AlertType.WARNING,
            okButtonText: "Enable Service", onPress: () async{
          Navigator.of(context).pop();

          Geolocator.openLocationSettings();

        });
        return null;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("001");
          showAlertDialog(context, "Location is permanently disabled",
              "Please enable the permission for better results!",
              type: AlertType.WARNING,
              okButtonText: "Grant Permission", onPress: () {
            Navigator.of(context).pop();
            Geolocator.openAppSettings();
          });

          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {

        showAlertDialog(context, "Location is permanently disabled",
            "Please enable the permission for better results!",
            type: AlertType.WARNING,
            okButtonText: "Grant Permission", onPress: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings();
            });
        return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('error while getting geolocation=> $e');
      return null;
    }
  }
}
