import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String _apiKey = "";
  static const String _modelo = 'openai/gpt-3.5-turbo';

  static Future<String> buscarPontosTuristicos(String endereco) async{
    final prompt = '''
      Considere o seguinte endereço ou ponto de referência: "$endereco". 
      Crie uma breve descrição criativa sobre os principais pontos turísticos nas proximidades.
        ''';

    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final response = await http.post(uri,
    headers: {
      'Authorization' : 'Bearer $_apiKey',
      'Content-type': 'application/json',
      'X-title': 'busca-turismo'
    },
      body: jsonEncode({
        'model': _modelo,
        'messages': [
          {'role': 'user', 'content': prompt }
        ],
      }),
    );

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    }else{
      return 'Não foi possível consultar a IA';
    }
  }
}