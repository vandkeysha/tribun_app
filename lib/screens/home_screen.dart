import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/category_chip.dart';
import 'package:tribun_app/widgets/custom_bottom.dart';
import 'package:tribun_app/widgets/explore_more.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';
import 'package:tribun_app/widgets/custom_appbar.dart';
import 'package:tribun_app/widgets/recommended.dart';



class HomeScreen extends GetView<NewsController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      // ✅ panggil bottom bar-nya di bawah sini
      bottomNavigationBar: const CustomBottomBar(),

      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            CustomAppBar(),

            // Body Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories
                      Container(
                        color: AppColors.primary,
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: controller.categories.map((category) {
                              return CategoryChip(
                                label: category.capitalizeFirst!,
                                isSelected:
                                    controller.selectedCategory == category,
                                onTap: () =>
                                    controller.selectCategory(category),
                              );
                            }).toList(),
                          );
                        }),
                      ),

                      const SizedBox(height: 16),

                      // Recommended
                      RecommendedSection(controller: controller),

                      const SizedBox(height: 24),

                      // Explore more
                      ExploreMoreSection(controller: controller),

                      const SizedBox(height: 24),

                      // News List
                      Obx(() {
                        if (controller.isLoading) {
                          return const LoadingShimmer();
                        }
                        if (controller.error.isNotEmpty) {
                          return _buildErrorWidget();
                        }
                        if (controller.articles.isEmpty) {
                          return _buildEmptyWidget();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: controller.articles.map((article) {
                              return NewsCard(
                                articles: article,
                                ontap: () => Get.toNamed(
                                  Routes.NEWS_DETAIL,
                                  arguments: article,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================
  // Widget Empty/Error
  // ===========================
  Widget _buildEmptyWidget() {
    return const Padding(
      padding: EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.newspaper, size: 64, color: AppColors.textHint),
            SizedBox(height: 16),
            Text(
              'No news available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please try again later',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Padding(
      padding: EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
