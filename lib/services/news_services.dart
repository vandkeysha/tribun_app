import 'dart:convert';

import 'package:tribun_app/models/news_response.dart';
import 'package:tribun_app/utils/constants.dart';
// maksdunya adalah mendefinisikan sebuah package atau library menjadi sebuah variable secara langsung.
import 'package:http/http.dart' as http;

class NewsServices {
  static const String _baseUrl = Constants.baseURL;
  static final String _apikey = Constants.apiKey;

  // fungsi yang bertujuan untuk membuat request GET ke server.
  Future<NewsResponse> getTopHeadlines({
    String country = Constants.defaultCountry,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String,String> queryParams = {
        'apiKey':_apikey,
        'country':country,
        'page':page.toString(),
        'pageSize':pageSize.toString()
      };

      // statement yang akan dijalankan ketika category tidak kosong.
      if (category != null && category.isNotEmpty ) {
        queryParams['category'] = category;
      }
      //berfungsi untuk parsing data dari json ke UI
      // simpel nya kita daftarin baseURL + endpoint yang akan digunakan.
      final uri = Uri.parse('$_baseUrl${Constants.topHeadLines}')
      .replace(queryParameters: queryParams);

      // untuk menyimpan respon yg diberikan oleh server.
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
      } else {
        
      }
      // e itu sama dengan error
    } catch (e) {
    
    }
  }
}