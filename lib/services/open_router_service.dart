import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String _apiKey = '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'; // Substitua pela sua chave
  static const String _model = 'openai/gpt-3.5-turbo';

  static Future<String> buscarPontosTuristicosIA(String endereco) async {
    final prompt = '''
Considere o seguinte endereço ou ponto de referência: "$endereco".
Crie uma breve descrição criativa sobre os principais pontos turísticos nas proximidades, com sugestões para um passeio interessante. Liste pelo menos 3 lugares com detalhes atrativos.
''';

    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'X-Title': 'busca-turistica'
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.8,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print('Erro na API: ${response.statusCode}');
      return 'Não foi possível gerar os dados turísticos.';
    }
  }
}