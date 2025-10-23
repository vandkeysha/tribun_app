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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300, // untuk ukuran image nya bisa di ubah sesuai keinginan
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: articles.urlToImage != null 
                  ? CachedNetworkImage(
                      imageUrl: articles.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.divider,
                        child: Center(
                          child: CircularProgressIndicator(), // buat ngeload kalau gambarnya tidak muncul
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.divider,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.textHint,
                        ),
                      ),
                    ) // untuk mengatur size image dari networkimage

                    // statenment yang akan dijalankan ketika server tidak memiliki gambar atau 
                    // => image == null
                      :Container(
                        color: AppColors.divider,
                        child: Icon(
                         Icons.newspaper,
                          size: 50,
                          color: AppColors.textHint,
                      ),
                    )
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareArticle(),
              ),
              PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':  // ketika user milih copy link
                      _copyLink();
                      break;
                      case 'open_browser':  // ketika user milih open browser
                      _openInBrowser();
                    break;
                  }
                },
                itemBuilder: (context) => [  
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('copy Link')
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(height: 8),
                        Text('open in browser')
                      ],
                    ),
                  )
                ],
               )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //source and date
                  Row(
                    children: [
                      if (articles.source?.name != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1), // untuk membuat warnany menjadi lebih terang
                            borderRadius: BorderRadius.circular(4)
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
                        SizedBox(width: 12),
                      ],
                      if (articles.publishedAt != null) ...[
                        Text(
                          timeago.format(DateTime.parse(articles.publishedAt!)),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ]
                    ],
                  ),
                   SizedBox(height: 16),
                   // title
                   if (articles.title != null) ...[
                    Text(
                      articles.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.3
                      ),
                    ),
                    SizedBox(height: 16),
                   ],
                    // description
                    if (articles.description != null) ...[
                      Text(
                        articles.description!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          height: 1.5
                        ),
                      )
                    ],
                    SizedBox(height: 20),
                    // content
                    if(articles.content != null) ...[
                      Text(
                        articles.content!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        articles.content!,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          height: 1.6
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                    // button read full articles
                    if (articles.url != null) ...[
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openInBrowser,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                            ),
                            child: Text(
                              'read full article,',
                              style: TextStyle(
                                fontSize: 16,
                                
                              ),
                            ),
                          ),
                      )
                    ],
                    SizedBox(height: 32),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _shareArticle(){
    if (articles.url != null) {
      Share.share(
        '${articles.title ?? 'check out this news'}\n\n${articles.url!}', // n/n/ untuk nambahin line baru
        subject: articles.title
      );
    }
  }
  void _copyLink(){
    if (articles.url != null) {
      Clipboard.setData(ClipboardData(text: articles.url!));   //clipboard ketika melakukan copy 
      Get.snackbar( 
        'Succes',
        'link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      ); 
    }
  }

  void _openInBrowser() async{
    if (articles.url != null) {
      final Uri url = Uri.parse(articles.url!);
       // proses menunggu apakah  url valid dan bisa dibuka oleh browser
      if (await canLaunchUrl(url)) {
       // proses menunggu ketika url udh valid dan sedang di proses oleh browser sampai datanya muncul
        await launchUrl(url, mode: LaunchMode.externalApplication);  
      } else {
        Get.snackbar(   
          'ErrorWidget',
          "couldn't open the link",
          snackPosition: SnackPosition.BOTTOM
        );
      }
    }
  }
}