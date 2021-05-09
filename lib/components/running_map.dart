import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/pace_detail.dart';
import 'package:running_app/models/track.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:running_app/screens/screen.dart';
import 'package:http/http.dart' as http;
import 'package:running_app/util/calories_burned_calculator.dart';
import 'package:running_app/util/health_util.dart';
import 'package:running_app/util/string_util.dart';

class RunningMap extends StatefulWidget {
  @override
  _RunningMapState createState() => _RunningMapState();
}

class _RunningMapState extends State<RunningMap> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = new Location();
  Marker marker;
  Circle circle;
  List<LatLng> points = [];
  GoogleMapController _controller;
  CameraPosition initLocation;
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;
  double _totalDistance = 0;
  double _currentLat = 0;
  double _currentLng = 0;
  List<PaceDetail> paces = [];
  double _avgPace = 0;
  DateTime _startTime;

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/my_location_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      // circle = Circle(
      //   circleId: CircleId("car"),
      //   radius: newLocalData.accuracy,
      //   zIndex: 1,
      //   strokeColor: Colors.blue,
      //   center: latlng,
      //   fillColor: Colors.blue.withAlpha(70),
      //   strokeWidth: 5,
      // );

      if (_stopwatch.isRunning) {
        marker = Marker(
            markerId: MarkerId("home"),
            position: latlng,
            rotation: newLocalData.heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData));
        if (points.length > 0) {
          _totalDistance += calculateDistance(_currentLat, _currentLng,
              newLocalData.latitude, newLocalData.longitude);
        }
        if (_totalDistance > 0) {
          _avgPace = (_stopwatch.elapsedMilliseconds / 60000) / _totalDistance;
          paces.add(PaceDetail(
              distance: _totalDistance,
              pace: num.parse(_avgPace.toStringAsFixed(2))));
        }
        //if (_totalDistance.floor() - 1 > paces.length) {
        // paces.add(PaceDetail(distance: totalDistance, pace: num.parse(_avgPace.toStringAsFixed(2))));
        //}
        points.add(LatLng(newLocalData.latitude, newLocalData.longitude));
        _currentLat = newLocalData.latitude;
        _currentLng = newLocalData.longitude;
      }
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      initLocation = CameraPosition(
          //bearing: 192.8334901395799,
          target: LatLng(location.latitude, location.longitude),
          tilt: 0,
          zoom: 12.0);
      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null && _stopwatch.isRunning) {
          var currentLocation = CameraPosition(
              //bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 16.0);
          _controller
              .animateCamera(CameraUpdate.newCameraPosition(currentLocation));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  DateTime convertMilliSecondsToDateTime(int milliseconds) {
    int secs = milliseconds ~/ 1000;
    int hours = (secs ~/ 3600);
    int minutes = ((secs % 3600) ~/ 60);
    int seconds = (secs % 60);
    return DateTime(1900, 1, 1, hours, minutes, seconds);
  }

  void handleStartPause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      setState(() {
        marker = null;
      });
    } else {
      if (_stopwatch.elapsedMilliseconds == 0) {
        // expand screen

        _startTime = DateTime.now();
      }
      _stopwatch.start();
    }
    setState(() {}); // re-render the page
  }

  Future<Track> registerTrack(Track track) async {
    var url = baseUrl + "/addtrack";
    var body = jsonEncode(track.toJson());
    await http.post(url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: body);
  }

  Future<void> handleFinish(BuildContext context) async {
    DateTime duration =
        convertMilliSecondsToDateTime(_stopwatch.elapsedMilliseconds);
    CaloriesBurnedCalculator caloriesBurnedCalc = new CaloriesBurnedCalculator(
        80, duration.hour, duration.minute, duration.second, _totalDistance);

    DateTime finishTime = DateTime.now();
    HealthUtil healthUtil = new HealthUtil(_startTime, finishTime);
    healthUtil.fetchData();

    Track track = Track(
        //trackId: 1,
        image: "",
        distance: num.parse(_totalDistance.toStringAsFixed(2)),
        calories: caloriesBurnedCalc.calcCaloriesBurned(),
        pace: num.parse(_avgPace.toStringAsFixed(2)),
        date: StringUtils.convertDateToString(DateTime.now()),
        duration: StringUtils.convertTimeToString(duration),
        avgStep: healthUtil.getStep(),
        maxStep: healthUtil.getStep(),
        avgHeartRt: 120,
        imageBytes: await _controller.takeSnapshot(),
        paceList: paces);

    // save to db
    await registerTrack(track);

    // display summary
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackDetail(
            currentTrack: track,
          ),
        ));
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    if (_controller != null) {
      _controller.dispose();
    }
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "RUN",
        ),
      ),
      body: initLocation != null
          ? Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                      color: Colors.white,
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      //color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              child: Text(
                            "Time",
                            style: TextStyle(fontSize: 12),
                          )),
                          Container(
                              child: Text(
                            formatTime(_stopwatch.elapsedMilliseconds),
                            style: TextStyle(fontSize: 48),
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Avg. Pace",
                                      style: TextStyle(fontSize: 12),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Distances",
                                      style: TextStyle(fontSize: 12),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _avgPace.isNaN
                                          ? "0"
                                          : NumberFormat("#").format(_avgPace),
                                      style: TextStyle(fontSize: 26),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      NumberFormat("#0.00")
                                              .format(_totalDistance) +
                                          " KM.",
                                      style: TextStyle(fontSize: 26),
                                    )),
                              )
                            ],
                          )
                        ],
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    // myLocationEnabled: true,
                    // tiltGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: initLocation,
                    markers: Set.of((marker != null) ? [marker] : []),
                    // circles: Set.of((circle != null) ? [circle] : []),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      getCurrentLocation();
                    },
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("p1"),
                        color: Colors.lightGreen,
                        points: points,
                      )
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _stopwatch.isRunning
                      ? Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          //color: Colors.white,
                          child: MaterialButton(
                            onPressed: handleStartPause,
                            child: Text('PAUSE'),
                            color: Colors.greenAccent,
                            minWidth: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ))
                      : _stopwatch.elapsedMilliseconds == 0
                          ? Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              //color: Colors.white,
                              child: MaterialButton(
                                onPressed: handleStartPause,
                                child: Text('START'),
                                color: Colors.greenAccent,
                                minWidth: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ))
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                      height: 55,
                                      alignment: Alignment.center,
                                      //color: Colors.white,
                                      child: MaterialButton(
                                        onPressed: handleStartPause,
                                        child: Text('RESUME'),
                                        color: Colors.greenAccent,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                      height: 55,
                                      alignment: Alignment.center,
                                      //color: Colors.white,
                                      child: MaterialButton(
                                        onPressed: () {
                                          handleFinish(context);
                                        },
                                        child: Text('FINISH'),
                                        color: Colors.green,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      )),
                                ),
                              ],
                            ),
                ),
              ],
            )
          : Container(
              child: Center(
                child: Text("Loading..."),
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
            ),
    );
  }
}
