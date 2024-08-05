import 'quote_model_v1.dart';
import 'service_api.dart';

const apiUrl = 'https://type.fit/api/quotes';

class QuoteRepository {
  final QuoteApiClient _apiClient = QuoteApiClient();

  static List<Quote> _quotesList = [];
  static List<Quote> favoriteQuotesList = [];
  int _currentIndex = 0;

  // Singleton factory
  static final QuoteRepository _instance = QuoteRepository._internal();

  factory QuoteRepository() {
    return _instance;
  }

  QuoteRepository._internal();

  Future<Quote> get getQuote async {
    if (_quotesList.isEmpty || _quotesList.length == 1) {
      _quotesList = (await _apiClient.fetchRandomQuoteList(
          apiUrl: apiUrl)); // Casting not needed in Dart 2.12
      return Quote(
          text: "Welcome to Quote of the Day", author: "Srinivas Rao T");
    }

    if (_currentIndex == _quotesList.length - 1) {
      _quotesList = await _apiClient.fetchRandomQuoteList(apiUrl: apiUrl);
      _currentIndex = 0;
    }

    return _quotesList[_currentIndex++];
  }

  Future<List<Quote>> fetchFavoriteQuotes() async {
    // TODO: Implement fetchFavoriteQuotes
    return [];
  }

  Future<void> deleteFavoriteQuote(Quote quote) async {
    // TODO: Implement deleteFavoriteQuote
  }

  Future<void> saveFavoriteQuote(Quote quote) async {
    // TODO: Implement saveFavoriteQuote
  }
  Stream<Quote> generateQuotes(int count) async* {
    for (int i = 0; i < count; i++) {
      yield await getQuote;
    }
  }
}

Future<void> main() async {
  // QuoteRepository quoteRepository = QuoteRepository();
  print(await QuoteRepository().getQuote);

  await for (var i in QuoteRepository().generateQuotes(20)) {
    print(i);
  }
}
