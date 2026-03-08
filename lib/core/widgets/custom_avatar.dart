import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Colores pastel para avatares.
const List<Color> _pastelColors = [
  Color(0xFFB3E5FC), // azul pastel
  Color(0xFFC8E6C9), // verde pastel
  Color(0xFFFFF9C4), // amarillo pastel
  Color(0xFFFFCCBC), // naranja pastel
  Color(0xFFE1BEE7), // púrpura pastel
  Color(0xFFBBDEFB), // azul claro pastel
  Color(0xFFF8BBD0), // rosado pastel
  Color(0xFFD7CCC8), // café pastel
];

/// Avatar circular reutilizable con placeholder.
class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? initials;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.initials,
    this.onTap,
    this.showEditIcon = false,
  });

  Color _colorFromInitials(String text) {
    final index = text.codeUnits.fold<int>(0, (sum, c) => sum + c) % _pastelColors.length;
    return _pastelColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final displayInitials = initials ?? '?';
    final bgColor = _colorFromInitials(displayInitials);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundColor: bgColor,
            child: Text(
              displayInitials,
              style: AppTextStyles.heading3.copyWith(
                color: Colors.black87,
                fontSize: size * 0.35,
              ),
            ),
          ),
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: size * 0.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
