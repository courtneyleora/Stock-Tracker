import 'dart:convert';
import 'package:http/http.dart' as http;

final String api = 'd07q8r1r01qp8st5onu0d07q8r1r01qp8st5onug';

Future<List<Map<String, dynamic>>> searchfunc(String query) async {
  final url = Uri.parse('https://finnhub.io/api/v1/search?q=$query&token=$api');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['result']);
  } else {
    throw Exception('API Handling Error');
  }
}

Future<double> getprice(String symbol) async {
  final url = Uri.parse(
    'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$api',
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['c'];
  } else {
    throw Exception('API Handling Error');
  }
}

Future<List<Map<String, dynamic>>> getRecommendationData(String symbol) async {
  final apiKey = 'd0b5ejhr01qo0h63f5l0d0b5ejhr01qo0h63f5lg';
  final url =
      'https://finnhub.io/api/v1/stock/recommendation?symbol=$symbol&token=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load recommendation data');
  }
}
