
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapasPage extends StatefulWidget{
  final double latitude;
  final double longetude;

  const MapasPage({
    Key? key,
    required this.latitude,
    required this.longetude
  }) : super(key: key);

  @override
  _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage>{

  final _controller = Completer<GoogleMapController>();
  StreamSubscription<Position>? _subscription;

  @override
  void initSate(){
    super.initState();
    _monitorarLocalizacao();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa Interno')),
      body: Container()
    );
  }

  void _monitorarLocalizacao(){
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100
    );

    _subscription = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) async {
          final controller = await _controller.future;
          final zoom = await controller.getZoomLevel();
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                zoom: zoom
              )));
    });
  }
}