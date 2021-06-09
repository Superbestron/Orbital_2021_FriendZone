import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  late Completer<GoogleMapController> controller1;

  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  static LatLng _currentPosition = LatLng(1.290270, 103.851959);

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(_currentPosition);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        markers: _markers,
        mapType: _currentMapType,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14.4746,
        ),
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
