
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ResultadoPage extends StatefulWidget{
  final String texto;

  const ResultadoPage({ Key? key, required this.texto}): super(key: key);

  _ResultadoPageState createState() => _ResultadoPageState();

}

class _ResultadoPageState extends State<ResultadoPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Pontos Turísticos Encontrados")),
      body: Padding(
          padding: const EdgeInsets.all(10),
        child: Center(
          child: DefaultTextStyle(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(widget.texto, speed: Duration(microseconds: 35)),
                  ],
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
              )
          ),
        ),
      ),
    );

  }
}