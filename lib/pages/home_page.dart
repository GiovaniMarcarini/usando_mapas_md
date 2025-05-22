

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:usando_mapas_md/pages/mapas_page.dart';

class HomePage extends StatefulWidget{

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  Position? _localizacaoAtual;
  final _controller = TextEditingController();
  final _controllerPontos = TextEditingController();

  String get _textoLocalizacao => _localizacaoAtual == null ? '' : 'Latitude: ${_localizacaoAtual!.latitude}  |  Longetude: ${_localizacaoAtual!.longitude}';

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Testando Mapas')),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => ListView(
    children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
            onPressed: _obterLocalizacaoAtual,
            child: const Text('Obter Localização Atual')
        ),
      ),
      if (_localizacaoAtual != null)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                  child: Text(_textoLocalizacao)
              ),
              ElevatedButton(
                  onPressed: _abrirNoMapaExternoCoordenadas,
                  child: const Icon(Icons.map)
              ),
              ElevatedButton(
                  onPressed: _abrirNoMapaInterno,
                  child: const Icon(Icons.map)
              ),
            ],
          ),
                
        ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Endereço ou ponto de referência',
            suffixIcon: IconButton(
                onPressed: _abrirNoMapaExterno,
                icon: const Icon(Icons.map),
              tooltip: 'Abrir no mapa',
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: _controllerPontos,
          decoration: InputDecoration(
            labelText: 'Buscar pontos de turismo próximos a:',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.psychology_alt_sharp),
              tooltip: 'USAR IA',
            ),
          ),
        ),
      ),
    ],
  );

  void _abrirNoMapaExterno() {
    if(_controller.text.trim().isEmpty){
      return;
    }
    MapsLauncher.launchQuery(_controller.text);
  }

  void _abrirNoMapaInterno(){
    if(_localizacaoAtual == null){
      return;
    }
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => MapasPage(
            latitude: _localizacaoAtual!.latitude,
            longetude: _localizacaoAtual!.longitude
        ),
    ));
  }

  void _abrirNoMapaExternoCoordenadas(){
    if(_localizacaoAtual == null){
      return;
    }
    MapsLauncher.launchCoordinates(
        _localizacaoAtual!.latitude,
        _localizacaoAtual!.longitude
    );
  }

  void _obterLocalizacaoAtual() async{
    bool servicoHabilitado = await _servicoHabilitado();

    if(!servicoHabilitado){
      return;
    }

    bool permissoesPermitidas = await _permissoePermitidas();
    if(!permissoesPermitidas){
      return;
    }

    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });
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