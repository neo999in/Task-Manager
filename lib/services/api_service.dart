import 'dart:convert';
import 'package:http/http.dart' as http;

class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      content: json['quote'] ?? json['content'] ?? '',
      author: json['author'] ?? '',
    );
  }
}

class ApiService {
  static const String _quoteUrl = 'https://dummyjson.com/quotes/random';

  Future<Quote?> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_quoteUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        } else if (data is Map<String, dynamic>) {
          return Quote.fromJson(data);
        }
      } else {
        print('Error fetching quote: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quote: $e');
    }
    return null;
  }
}
