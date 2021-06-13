import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:location/location.dart';
import 'package:myapp/models/event.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/constants.dart';

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
  Set<Marker> _markers = {};
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
    List<Event> events = (Provider.of<List<Event>?>(context) ?? []);

    // Filter the events which have already happened
    events.removeWhere((event) => event.dateTime.isBefore(DateTime.now()));

    // initialise markers
    setState(() {
      _markers = Set.of(events.map((event) => Marker(
        markerId: MarkerId(event.eventID),
        onTap: () {
          print("Hello");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Stack(
                  fit: StackFit.expand,
                  children: <Widget> [
                    SvgPicture.asset(
                      'assets/background.svg',
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                    ),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      // AppBar that is shown on event_page
                      appBar: AppBar(
                        leading: BackButton(color: Colors.black),
                        title: Text(
                          "Event Details",
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget> [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                            child: imageList[event.icon],
                          ),
                        ],
                        toolbarHeight: 75.0,
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                      ),
                      body: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 60.0),
                        child: EventPage(eventID: event.eventID),
                      ),
                    ),
                  ],
                ),
              )
          );
        },
        position: LatLng(37.422, -122.084), // TODO: change to get data from database
      )));
    });

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
