import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:one_food/widgets/common_widgets.dart';
import 'package:one_food/utils/location_distance_places.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Example',
      theme: ThemeData.light(),
      home: SelectLocation(),
    );
  }
}

bool isGPSEnabled = false;

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

StreamController<bool> streamController = StreamController();
Stream<bool> stream = streamController.stream;

StreamController<bool> myStreamController = StreamController();
Stream<bool> myStream = myStreamController.stream;

class _SelectLocationState extends State<SelectLocation> {
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);

  StreamSubscription<Position> positionStream;

  double latitude = 18.7890, longitude = 78.2911;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  checkPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);

    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      streamController.add(false);
      myStreamController.add(false);
      print('Location permissions not granted');
      //LocationServicesDialogBox(context).show();
      print("$permissions");
      if (permissions[PermissionGroup.location] != PermissionStatus.granted)
        GPSServicesDialog(context).show();
    } else {
      streamController.add(true);
      myStreamController.add(true);
      setState(() {
        isGPSEnabled = true;
      });
      print("$permissions");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMapSetup = false;
    GoogleMapController myMapController;

    positionStream =
        geolocator.getPositionStream(locationOptions).handleError((error) {
      print("Error occured  " + error.toString());
    }).listen((Position position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
//      print("User\'s location changed : " +
//          position.latitude.toString() +
//          " " +
//          position.longitude.toString());
      if (isMapSetup)
        myMapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 15.0));
    });

    var accesstoken =
        "pk.eyJ1Ijoib25lZm9vZCIsImEiOiJjanc0eWNqa2owZWtjNGFtczgydjd1N2Y2In0.KaNqdk6s4wEQChdx0vuNrQ";

    Set<Marker> markers = Set();
    markers.add(Marker(
      markerId: MarkerId('1'),
      alpha: 1.0,
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
//        print('Marker tapped');
      },
      position: LatLng(latitude, longitude),
    ));

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
              child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(latitude, longitude)),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              //print('MapController setup');
              isMapSetup = true;
              myMapController = controller;
              if (latitude != null && longitude != null)
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(latitude, longitude), zoom: 15.0)));
            },
            compassEnabled: true,
            markers: markers,
            onCameraMove: (CameraPosition cameraPosition) {
              LatLng lng = cameraPosition.target;
              latitude = lng.latitude;
              longitude = lng.longitude;
              setState(() {});
              //print('Camera Position Changed(camera moved) ' + lng.toString());
            },
            onTap: (LatLng l) {
              setState(() {
                latitude = l.latitude;
                longitude = l.longitude;
              });
//              print('Camera Position Changed(tapped) ' + l.toString());
            },
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapType: MapType.terrain,
          )),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                StreamBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.data == true)
                      return Container();
                    else
                      return SizedBox(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 8 / 10,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          elevation: 20.0,
                          child: Text(
                            'Enable GPS',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            AppSettings.openLocationSettings()
                                .whenComplete(() async {
                              Map<PermissionGroup, PermissionStatus>
                                  permissions = await PermissionHandler()
                                      .requestPermissions(
                                          [PermissionGroup.location]);
                              if (permissions[PermissionGroup.location] ==
                                  PermissionStatus.granted) {
                                print('Permission granted here');
                                isGPSEnabled = true;
                                streamController.add(true);
                                myStreamController.add(true);
                              } else {
                                print("Permission not granted here");
                                isGPSEnabled = false;
                                myStreamController.add(false);
                              }
                            });
                          },
                          color: Colors.blue,
                        ),
                      );
                  },
                  initialData: false,
                  stream: stream,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Adjust the pin and select the location',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width * 8 / 10,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 20.0,
                    child: Text(
                      'Select Location',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      var result = await MyGeoCoder.addressFromLatLong(
                          latitude, longitude);
//                      print(result.toString());
//                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
//                          builder: (BuildContext context) => SelectLocation()));
                    },
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 15.0)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GPSServicesDialog {
  BuildContext buildContext;
  String message = "Please enable the location services to continue",
      title = "GPS Disabled";

  GPSServicesDialog(this.buildContext);

  void show() {
    _showDialog();
  }

  Future _showDialog() {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('$title'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openLocationSettings().whenComplete(() async {
                  Map<PermissionGroup, PermissionStatus> permissions =
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.location]);
                  if (permissions[PermissionGroup.location] ==
                      PermissionStatus.granted) {
                    print('Permission granted here');
                    isGPSEnabled = true;
                    streamController.add(true);
                    myStreamController.add(true);
                  } else {
                    print("Permission not granted here");
                    isGPSEnabled = false;
                    myStreamController.add(false);
                  }
                });
              },
            )
          ],
          content: SizedBox(
            height: 45.0,
            child: Center(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
        );
      },
    );
    return null;
  }
}
