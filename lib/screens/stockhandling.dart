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
