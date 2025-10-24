import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:tribun_app/bindings/app_bindings.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';

void main() async { // yg pakai * adalah untuk mengambil semuanya 
  WidgetsFlutterBinding.ensureInitialized(); // untuk make sure kalau  prosesnya bener bener berjalan

  // load environmet variables first before running the app
  await dotenv.load(fileName: '.env'); // . env adalah tempat kita meletakkan API_KEY

  runApp(TribunApp());
}

class TribunApp extends StatelessWidget {
  const TribunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // karna kita pakai state getx maka dari itu kita pakai getmaterial bukan materialApp
      title: 'Tribun App',
      theme: ThemeData( // tema aplikasi seluru data
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white
          )
        )
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(), //  binding ngurusin agar kontroller bisa keurus dengan baik
      debugShowCheckedModeBanner: false, // untuk menghilangin banner merah merah yg diatas
    ); 
  }
}