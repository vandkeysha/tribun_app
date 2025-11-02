import 'package:get/get.dart';
import 'package:tribun_app/bindings/home_bindings.dart';
import 'package:tribun_app/screens/home_screen.dart';
import 'package:tribun_app/screens/news_detail_screen.dart';
import 'package:tribun_app/screens/splash_screen.dart';
import 'package:tribun_app/screens/search_screen.dart';
import 'package:tribun_app/screens/saved_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBindings(), // Memanggil semua controller
    ),
    GetPage(
      name: Routes.NEWS_DETAIL,
      page: () => NewsDetailScreen(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: Routes.SAVED,
      page: () => SavedScreen(),
    ),
  ];
}
