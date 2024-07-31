import 'dart:async';

import 'package:http/http.dart' show get, Response;
import 'dart:convert';


class Quote {
  // required fields
  final String text;
  final String author;

  // optional fields
  bool isFavorite = false;
  // set favorite(bool value) => isFavorite = value;
  // bool get favorite => isFavorite;

  // unique identifier
  late final int _idQuote;
  late final int _idAuthor;
  int get quoteID => _idQuote;
  int get authorID => _idAuthor;

  // constructor
  Quote({
    required this.text,
    required this.author,
  }) {
    _idQuote = text.hashCode;
    _idAuthor = author.hashCode;
  }

  // factory constructor
  // for creating a new Quote object from json
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] ?? '',
      author: json['author'] ?? 'Anonymous',
    )..isFavorite = json['isFavorite'] ?? false;
  }

  // method to convert list of Quote objects to list of json
  static List<Map<String, dynamic>> toJsonList({required List<Quote> quotes}) {
    return List<Map<String, dynamic>>.from(quotes.map((Quote item) {
      return item.toJson();
    }));
  }

  // method to convert list of json to list of Quote objects
  static List<Quote> fromJsonList({required List<dynamic> jsonList}) {
    return List<Quote>.from(jsonList.map((dynamic item) {
      return Quote.fromJson(item);
    }));
  }

  // method to convert list of json to list of Quote objects
  static Future<List<Quote>> fromJsonListFuture(
      {required List<dynamic> jsonList}) async {
    return List<Quote>.from(jsonList.map((dynamic item) {
      return Quote.fromJson(item);
    }));
  }

  // method to toggle favorite status
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  // method to convert object to json
  // this is useful when saving to local storage and when sending data to server
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'author': author,
      'isFavorite': isFavorite,
    };
  }

  // for creating a new Quote object from map
  factory Quote.fromMap(Map<String, dynamic> map) => Quote.fromJson(map);

  // method to convert object to map
  Map<String, dynamic> toMap() => toJson();

  @override
  String toString() {
    return '''
Quote{
  id: $_idQuote, 
  text: $text, 
  author: $author, 
  isFavorite: $isFavorite,
}''';
  }
}

// void main() {
//   // create a new Quote object
//   final Quote quote1 = Quote(text: 'Hello World', author: '');
//   print(quote1);
//   quote1.toggleFavorite();
//   final Quote quote2 = Quote.fromJson(
//       {'text': 'Hello World', 'author': 'Anonymous', 'isFavorite': true});
//   print(quote2);
// }

void main() async {
  // fetch quotes
  List<Quote> quotes = await fetchQuotes(url: apiUrl);

  // print quotes using toString()
  print(quotes);
}
const apiUrl = 'https://type.fit/api/quotes';

Future<List<Quote>> fetchQuotes({required String url}) async {
  try {
    final Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Successful request
      List<dynamic> dynamicDataList = jsonDecode(response.body);

      // Convert dynamic data to List<Quote>
      return Quote.fromJsonListFuture(jsonList: dynamicDataList);
    } else {
      // Request failed with status: 404
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Request failed with exception: SocketException: Failed host lookup: 'type.fit'
    return [Quote(text: e.runtimeType.toString(), author: 'Qoute API')];
  }
}
