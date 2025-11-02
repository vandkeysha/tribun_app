import 'package:get/get.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/services/news_services.dart';
import 'package:tribun_app/utils/constants.dart';

class NewsController extends GetxController {
  final NewsServices _newsServices = NewsServices();

  
  final _isLoading = false.obs;
  final _articles = <NewsArticles>[].obs;
  final _selectedCategory = 'general'.obs;
  final _selectedCountry = Constants.defaultCountry.obs;
  final _error = ''.obs;


  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get selectedCountry => _selectedCountry.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  
  final List<Map<String, String>> countries = [
    {'code': 'all', 'name': 'All Countries'},
    {'code': 'us', 'name': 'United States'},
    {'code': 'id', 'name': 'Indonesia'},
    {'code': 'jp', 'name': 'Japan'},
    {'code': 'gb', 'name': 'United Kingdom'},
    {'code': 'fr', 'name': 'France'},
    {'code': 'au', 'name': 'Australia'},
    {'code': 'cn', 'name': 'China'},
    {'code': 'kr', 'name': 'South Korea'},
    {'code': 'br', 'name': 'Brazil'},
  ];

  // === Fetch berita utama ===
  Future<void> fetchTopHeadlines({String? category, String? country}) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final selectedCountryCode = country ?? _selectedCountry.value;
      final selectedCategoryName = category ?? _selectedCategory.value;

      print('Fetching news for country: $selectedCountryCode');

   
      if (selectedCountryCode == 'all') {
        final response =
            await _newsServices.searchNews(query: selectedCategoryName);
        _articles.assignAll(response.articles);
        return;
      }


      if (NewsServices.supportedCountries.contains(selectedCountryCode)) {
        final response = await _newsServices.getTopHeadlines(
          country: selectedCountryCode,
          category: selectedCategoryName,
        );
        _articles.assignAll(response.articles);
      } else {

        print('⚠️ $selectedCountryCode not supported — using searchNews fallback');
        final response =
            await _newsServices.searchNews(query: selectedCategoryName);
        _articles.assignAll(response.articles);
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }


  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }


  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  
  void changeCountry(String newCountry) {
    print('🗺️ Changing country to: $newCountry');
    _selectedCountry.value = newCountry;
    fetchTopHeadlines(country: newCountry);
  }


  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.searchNews(query: query);
      _articles.assignAll(response.articles);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }


  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }
}
