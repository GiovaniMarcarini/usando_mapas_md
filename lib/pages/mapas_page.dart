
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa Interno')),
      body: Container()
    );
  }
}