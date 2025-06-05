import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ResultadoPage extends StatelessWidget {
  final String texto;

  const ResultadoPage({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pontos Turísticos Encontrados')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 18.0, color: Colors.black87),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(texto, speed: Duration(milliseconds: 35)),
                ],
                totalRepeatCount: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
