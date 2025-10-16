import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tribun_app/utils/app_colors.dart';

class CategoryChip extends StatelessWidget {

  final String label;
  final bool isSelected;
  final VoidCallback ontap;
  const CategoryChip({super.key, required this.label, required this.isSelected, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => ontap(),
        backgroundColor: Colors.grey[100],
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.secondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.transparent
          )
        ),
      ),
    );
  }
}