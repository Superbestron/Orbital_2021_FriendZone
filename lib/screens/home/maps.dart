import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:location/location.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    _runLocationService();
  }

  Completer<GoogleMapController> controller1 = Completer();
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  static LatLng _position = LatLng(0, 0);
  bool initialised = false;

  void _runLocationService() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    void updateLocation() async {
      _locationData = await location.getLocation();
      initialised = true;
      setState(() {
        _position = LatLng(_locationData.latitude!, _locationData.longitude!);
      });
      print(_position);
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      updateLocation();
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return initialised
        ? Container(
            child: GoogleMap(
              markers: _markers,
              mapType: _currentMapType,
              initialCameraPosition: CameraPosition(
                target: _position,
                zoom: 14.4746,
              ),
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
            ),
          )
        : TransparentLoading();
  }
}
