import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class ThirdScreen extends StatefulWidget {
  final latitude;
  final longitude;
  final placeName;
  ThirdScreen({
    Key key,
    this.latitude,
    this.longitude,
    this.placeName
  })
      : super(
    key: key,
  );
  @override
  _ThirdScreenState createState() => _ThirdScreenState(latitude,longitude,placeName);
}

class _ThirdScreenState extends State<ThirdScreen> {
  var latitude;
  var longitude;
  var placeName;
  _ThirdScreenState(this.latitude,this.longitude,this.placeName);
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set();

 CameraPosition _kLake;

  @override
  void initState(){
    super.initState();
    _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude, longitude),
        zoom: 15.151926040649414);
    _addSetOfMarker();
  }


  Future<void> _addSetOfMarker() async {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(placeName),
        position: LatLng(latitude, longitude),
      ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(placeName.toString()),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kLake,
        compassEnabled: true,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
