import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';

class RecommendedSection extends StatelessWidget {
  final NewsController controller;

  const RecommendedSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommended',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: nanti bisa diarahkan ke halaman khusus rekomendasi
                },
                child: const Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(color: Colors.amber),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_right_alt, color: Colors.amber),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),


          SizedBox(
            height: 240,
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final recommendedArticles = controller.articles.take(5).toList();
              if (recommendedArticles.isEmpty) {
                return const Center(
                  child: Text(
                    'No recommended news available',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedArticles.length,
                itemBuilder: (context, index) {
                  final article = recommendedArticles[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.NEWS_DETAIL,
                      arguments: article,
                    ),
                    child: Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === IMAGE ===
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage ?? '',
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                height: 130,
                                color: AppColors.divider,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              article.title ?? 'No title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              'See All →',
                              style: TextStyle(
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
