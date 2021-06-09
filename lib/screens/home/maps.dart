import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  Widget build(BuildContext context) {
    CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(22.5448131, 88.3403691),
      zoom: 15,
    );

    return Container(
      child: GoogleMap(
        initialCameraPosition: _cameraPosition,
      ),
    );
  }
}
