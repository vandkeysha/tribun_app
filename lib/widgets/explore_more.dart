import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/news_card.dart';

class ExploreMoreSection extends StatelessWidget {
  final NewsController controller;

  const ExploreMoreSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              "Explore More",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // === CONTENT (ARTICLES) ===
          Obx(() {
            if (controller.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(color: AppColors.onError),
                ),
              );
            }

            final articles = controller.articles;

            if (articles.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'No more destinations to explore',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }

  
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: articles.take(3).length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final article = articles[index];
                return NewsCard(
                  articles: article,
                  ontap: () => Get.toNamed(
                    Routes.NEWS_DETAIL,
                    arguments: article,
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
