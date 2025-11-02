import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/routes/app_pages.dart'; // pastikan ini udah ada ya

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.grid_view,     // home icon
    Icons.search,        // search icon
    Icons.bookmark,      // saved icon
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi sesuai index
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME); // ke home
        break;
      case 1:
        Get.toNamed(Routes.SEARCH); // ke search
        break;
      case 2:
        Get.toNamed(Routes.SAVED); // ke halaman simpan/bookmark
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_icons.length, (index) {
          final bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                _icons[index],
                color: isSelected ? Colors.white : Colors.grey,
                size: isSelected ? 30 : 26,
              ),
            ),
          );
        }),
      ),
    );
  }
}
