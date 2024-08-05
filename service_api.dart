import 'package:http/http.dart' show get, Response;
import 'dart:convert';
import 'quote_model_v1.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

const apiUrl = 'https://type.fit/api/quotes';



class QuoteApiClient {
  static final QuoteApiClient _instance = QuoteApiClient._internal();

  factory QuoteApiClient() {
    return _instance;
  }

  QuoteApiClient._internal();

  Future<Quote> fetchQuote({required String apiUrl}) async {
    try {
      final response = await get(Uri.parse(apiUrl));
      return _handleResponse(response);
    } on SocketException catch (e) {
      // Handle network errors
      return Quote(
          text: 'Network error: ${e.message}\n Try connecting to Network!',
          author: 'Quote API');
    } catch (e) {
      // Handle other errors
      return Quote(
          text: 'Unexpected error: ${e.runtimeType}', author: 'Quote API');
    }
  }

  Future<List<Quote>> fetchQuotesList({required String apiUrl}) async {
    try {
      final response = await get(Uri.parse(apiUrl));
      return _handleListResponse(response);
    } on SocketException catch (e) {
      // Handle network errors
      return [
        Quote(
            text: 'Network error: ${e.message}\n Try connecting to Network!',
            author: 'Quote API')
      ];
    } catch (e) {
      // Handle other errors
      return [
        Quote(text: 'Unexpected error: ${e.runtimeType}', author: 'Quote API')
      ];
    }
  }

  Future<List<Quote>> fetchRandomQuoteList({required String apiUrl}) async {
    List<Quote> quotesList = await fetchQuotesList(apiUrl: apiUrl);

    // Shuffle the list of quotes
    quotesList.shuffle(Random());

    return quotesList;
  }

  Quote _handleResponse(Response response) {
    if (response.statusCode != 200) {
      throw HttpException('Error getting quote: ${response.statusCode}');
    }
    final json = jsonDecode(response.body);
    return Quote.fromJson(json);
  }

  Future<List<Quote>> _handleListResponse(Response response) async {
    if (response.statusCode != 200) {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
    final List<dynamic> dynamicDataList = jsonDecode(response.body);
    return Quote.fromJsonListFuture(jsonList: dynamicDataList);
  }
}


void main() async {
  // Create an instance of QuoteApiClient
  final quoteApiClient = QuoteApiClient();
  // fetch quotes
  List<Quote> quotes = (await quoteApiClient.fetchQuotesList(apiUrl: apiUrl));

  // print quotes using toString()
  print(quotes);
}