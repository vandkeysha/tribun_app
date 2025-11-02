import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/controllers/news_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final NewsController newsController = Get.find();

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === TITLE ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFFFFD369),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'TerraGo',
                    style: TextStyle(
                      fontSize: 38,
                      color: Color(0xFFFFD369),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // === COUNTRY DROPDOWN ===
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: AppColors.primary,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white),
                    value: newsController.selectedCountry,
                    items: newsController.countries.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFFFFD369)),
                            const SizedBox(width: 6),
                            Text(
                              country['name']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        newsController.changeCountry(value);
                      }
                    },
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 20),

          // === SEARCH BAR ===
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFE9A0),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onSubmitted: (query) {
                      newsController.searchNews(query);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Find things to do',
                      hintStyle: TextStyle(color: AppColors.primary),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
