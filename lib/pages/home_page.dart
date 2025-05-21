

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget{

  const HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Testando Mapas')),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => ListView(
    children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
            onPressed: () {},
            child: Text('Obter Localização Atual')
        ),
      )
    ],
  );

  void _obterLocalizacaoAtual() async{
    bool servicoHabilitado = await _servicoHabilitado();

    if(!servicoHabilitado){
      return;
    }

    bool permissoesPermitidas = await _permissoePermitidas();
    if(!permissoesPermitidas){
      return;
    }

    Position? position = await Geolocator.getCurrentPosition();

  }

  Future<bool> _permissoePermitidas() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recurso por falta de'
            ' permissão!!!');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever){
      await _mostrarDialogMessagem(
          'Para utilizar esse recurso, você deverá acessar as configurações do app'
              ' e permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();

    if(!servicoHabilitado){
      await _mostrarDialogMessagem(
          'Para utiliar este recurso, você deverá habilitar o serviço de localização do dispositivo'
      );
      Geolocator.openLocationSettings();
      return false;
    }

    return true;
  }

  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensagem)
    ));
  }

  Future<void> _mostrarDialogMessagem(String mensagem) async{
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: const Text('ATENÇÃO'),
            content: Text(mensagem),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK')
              )
            ]
        )
    );
  }

}