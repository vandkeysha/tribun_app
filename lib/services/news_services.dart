import 'dart:convert';
import 'package:tribun_app/models/news_response.dart';
import 'package:tribun_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class NewsServices {
  static const String _baseUrl = Constants.baseURL;
  static final String _apikey = Constants.apiKey;


  static const List<String> supportedCountries = [
    'ae', 'ar', 'at', 'au', 'be', 'bg', 'br', 'ca', 'ch', 'cn',
    'co', 'cu', 'cz', 'de', 'eg', 'fr', 'gb', 'gr', 'hk', 'hu',
    'id', 'ie', 'il', 'in', 'it', 'jp', 'kr', 'lt', 'lv', 'ma',
    'mx', 'my', 'ng', 'nl', 'no', 'nz', 'ph', 'pl', 'pt', 'ro',
    'rs', 'ru', 'sa', 'se', 'sg', 'si', 'sk', 'th', 'tr', 'tw',
    'ua', 'us', 've', 'za'
  ];


  Future<NewsResponse> getTopHeadlines({
    String country = Constants.defaultCountry,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {

      if (!supportedCountries.contains(country)) {
        print('⚠️ Country $country not supported — using everything instead');
        return searchNews(query: category ?? 'news');
      }

      final Map<String, String> queryParams = {
        'apiKey': _apikey,
        'country': country,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final uri = Uri.parse('$_baseUrl${Constants.topHeadLines}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load top headlines: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching top headlines: $e');
    }
  }


  Future<NewsResponse> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
    String? sortBy,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'apiKey': _apikey,
        'q': query,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final uri = Uri.parse('$_baseUrl${Constants.everything}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return NewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load search results: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }
}
