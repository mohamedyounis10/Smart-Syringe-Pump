import 'package:flutter/material.dart';
import 'package:the_dose/core/app_color.dart';

Widget buildNavItem({
  required IconData icon,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: IconButton(
      icon: Icon(icon),
      iconSize: 26,
      color: isSelected ? AppColor.white : AppColor.white.withOpacity(0.6),
      onPressed: onTap,
    ),
  );
}