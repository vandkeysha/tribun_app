// A brand new way for make a screen using get state management

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/category_chip.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';

class HomeScreen extends GetView<NewsController>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
              onPressed: () => showSearchDialog(context),
          )
        ],
      ),
      body: Column(
        children: [
          // categories
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() => CategoryChip(
                  label: category.capitalize ?? category, // ?? itu adalah nilai default value
                  isSelected: controller.selectedCategory == category, // == menyamakan category
                  ontap: () => controller.selectCategory(category),
                ));
              },
            ),
          ),
          // news list 
          // expended untuk mengisi ruang kosong
          Expanded(
            child: Obx(
              (){
                if (controller.isloading) {
                  return LoadingShimmer();
                }
                if (controller.error.isNotEmpty) {
                  return _buildErrorWidget();
                }

                if (controller.articles.isEmpty) {
                  return _buildEmptyWidget();
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return NewsCard(
                        articles: article,
                        ontap: () => Get.toNamed(
                          // TODO: add route to detail screen,

                          // argument berfungsi untuk bernavigasi ke halaman lain dengan membawa data
                          arguments: article
                        ),
                      );
                    },
                  ),
                );
              }
            ),  // obx untuk memberi tahu ui kalau ada perubahan
          )
        ],
      ),
   );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: 64,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16),
          Text(
            'no news available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: 16),
          Text('Something went wrong',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary
           ),
          ),
          SizedBox(height: 8),
          Text(
            'please check your internet connection',
            style: TextStyle(
              color: AppColors.textSecondary
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshNews,
            child: Text('Retry'),
          )
        ],
      ),
    );
  }

 void showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search News'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Please type a news..',
            border: OutlineInputBorder()
          ),
          onSubmitted: (value){
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Search'),
          )
        ],
      ),
    );
  }
}