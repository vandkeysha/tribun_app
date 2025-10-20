part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
}

// pendeklarasian route dari masing masing screen
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const NEWS_DETAIL = '/news_detail';

}