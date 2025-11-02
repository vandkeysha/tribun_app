import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailScreen extends StatelessWidget {
  final NewsArticles articles = Get.arguments as NewsArticles;

  NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.cardShadow,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (articles.urlToImage != null)
                    CachedNetworkImage(
                      imageUrl: articles.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primary,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.white70,
                      ),
                    )
                  else
                    Container(
                      color: AppColors.divider,
                      child: const Icon(
                        Icons.newspaper,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
                  // gradient overlay biar teks jelas
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _shareArticle,
              ),
              PopupMenuButton(
                iconColor: Colors.white,
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                    case 'open_browser':
                      _openInBrowser();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('Copy Link')
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(width: 8),
                        Text('Open in Browser')
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardShadow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source & date
                  Row(
                    children: [
                      if (articles.source?.name != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            articles.source!.name!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      if (articles.publishedAt != null)
                        Text(
                          timeago.format(DateTime.parse(articles.publishedAt!)),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating bar (static contoh)
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 26),
                      Icon(Icons.star, color: Colors.amber, size: 26),
                      Icon(Icons.star, color: Colors.amber, size: 26),
                      Icon(Icons.star, color: Colors.amber, size: 26),
                      Icon(Icons.star_border, color: Colors.amber, size: 26),
                      SizedBox(width: 8),
                      Text(
                        "4.0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title
                  if (articles.title != null)
                    Text(
                      articles.title!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Description
                  if (articles.description != null)
                    Text(
                      articles.description!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),

                  const SizedBox(height: 18),

                  // Content
                  if (articles.content != null)
                    Text(
                      articles.content!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Button read full article
                  if (articles.url != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _openInBrowser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E4374),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Read full Articles',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareArticle() {
    if (articles.url != null) {
      Share.share(
        '${articles.title ?? 'Check out this news!'}\n\n${articles.url!}',
        subject: articles.title,
      );
    }
  }

  void _copyLink() {
    if (articles.url != null) {
      Clipboard.setData(ClipboardData(text: articles.url!));
      Get.snackbar(
        'Success',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _openInBrowser() async {
    if (articles.url != null) {
      final Uri url = Uri.parse(articles.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          "Couldn't open the link",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
