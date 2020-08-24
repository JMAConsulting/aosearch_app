import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentPosition;
  String currentAddress;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentPosition != null) Text(currentAddress),
        FlatButton(
          child: Text(
            'Use my location'
          ),
          onPressed: () {
            getCurrentLocation();
          },
        )
      ]
    );
  }

  getCurrentLocation() {
    geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    ).then((Position position) {
      setState(() {
        currentPosition = position;
      });

      getCurrentAddress();
    }).catchError((error) {
      print(error);
    });
  }

  getCurrentAddress() async {
    try {
      List<Placemark> placemark = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude);

      Placemark place = placemark[0];

      setState(() {
        currentAddress = '${place.subLocality} ${place.locality}';
      });
    } catch (error) {
      print(error);
    }
  }

}
