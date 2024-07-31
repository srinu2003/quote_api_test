import 'package:http/http.dart' show get, Response;
import 'dart:convert';
import 'quote_model_v0.dart';

const apiUrl = 'https://type.fit/api/quotes';

void main() async {
  // fetch quotes
  List<Quote> quotes = await fetchQuotes(url: apiUrl);

  // print quotes using toString()
  print(quotes);
}

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

