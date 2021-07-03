import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/screens/home/event_list.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:location/location.dart';
import 'package:myapp/models/event.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/widgets.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
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
      if (mounted) {
        setState(() {
          _position = LatLng(_locationData.latitude!, _locationData.longitude!);
        });
      }
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

  List getCoordinate(String location) {
    for (List item in LOCATIONS) {
      if (item[0] == location) {
        return [item[1], item[2]];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = (Provider.of<List<Event>?>(context) ?? []);

    // Filter the events which have already happened
    events.removeWhere((event) => event.dateTime.isBefore(DateTime.now()));

    // Filter events with no location defined
    events.removeWhere((event) => event.location == "Others");
    // initialise markers
    setState(() {
      _markers = Set.of(events.map((event) => Marker(
            markerId: MarkerId(event.eventID),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StreamProvider<List<Event>?>.value(
                    initialData: null,
                    value: DatabaseService.events.map((events) => (events
                        .where((element) => element.location == event.location)
                        .toList())),
                    child: Stack(fit: StackFit.expand, children: <Widget>[
                      buildBackgroundImage(),
                      Scaffold(
                          appBar: AppBar(
                            centerTitle: true,
                            leading: BackButton(color: Colors.black),
                            title: Text(
                              "Nearby events",
                              style: TextStyle(color: Colors.black),
                            ),
                            toolbarHeight: 100.0,
                            elevation: 0.0,
                          ),
                          body: EventList())
                    ]));
              }));
            },
            position: LatLng(getCoordinate(event.location)[0],
                getCoordinate(event.location)[1]),
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
