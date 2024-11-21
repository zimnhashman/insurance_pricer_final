import 'dart:convert';
import 'package:http/http.dart' as http;

class CarApiService {
  final String apiToken;
  final String apiSecret;
  String? jwt;

  CarApiService({required this.apiToken, required this.apiSecret});

  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('https://carapi.app/api/auth/login'),
      headers: {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'api_token': apiToken,
        'api_secret': apiSecret,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      jwt = data['jwt']; // Store the JWT for future requests
    } else {
      throw Exception('Failed to authenticate: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchVehicleModels() async {
    if (jwt == null) {
      await authenticate();
    }

    final response = await http.get(
      Uri.parse('https://carapi.app/api/models'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load vehicle models: ${response.statusCode}');
    }
  }
}
