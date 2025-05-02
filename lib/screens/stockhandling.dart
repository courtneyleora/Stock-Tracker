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

Future<List<Map<String, dynamic>>> getHistoricalData(String symbol) async {
  final url = Uri.parse(
    'https://finnhub.io/api/v1/stock/candle?symbol=$symbol&resolution=D&from=1680307200&to=1682899200&token=$api',
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['s'] == 'ok') {
      final timestamps = data['t'] as List<dynamic>;
      final prices = data['c'] as List<dynamic>;

      return List.generate(
        timestamps.length,
        (index) => {
          'time': DateTime.fromMillisecondsSinceEpoch(timestamps[index] * 1000),
          'price': prices[index],
        },
      );
    } else {
      throw Exception('No data available');
    }
  } else {
    throw Exception('API Handling Error');
  }
}
