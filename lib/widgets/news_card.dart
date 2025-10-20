import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatelessWidget {
  final NewsArticles articles;
  final VoidCallback ontap;

  const NewsCard({super.key, required this.articles, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only( bottom: 16),
      elevation: 2,
      shadowColor: AppColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            if (articles.urlToImage != null )
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: articles.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppColors.divider,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: AppColors.divider,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // source news and date
                    Row(
                      children: [
                        if (articles.source?.name != null)...[
                          Expanded(
                            child: Text(
                              articles.source!.name!,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis,
                             )
                          ),
                          SizedBox(width: 8),
                        ],
                        // timestemp
                        if (articles.publishedAt != null)
                          Text(
                            timeago.format(DateTime.parse(articles.publishedAt!)),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12
                            ),
                         )
                      ],
                    ),
                    SizedBox(height: 12),

                    // title
                      if (articles.title != null)
                      Text(
                        articles.title!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      // description
                      if (articles.description != null)
                      Text(
                        articles.description!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}