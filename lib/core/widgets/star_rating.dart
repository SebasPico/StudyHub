import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../theme/app_colors.dart';

/// Widget de rating con estrellas reutilizable.
class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool allowEdit;
  final ValueChanged<double>? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.allowEdit = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: !allowEdit,
      itemCount: 5,
      itemSize: size,
      unratedColor: AppColors.starEmpty,
      itemBuilder: (context, _) => const Icon(
        Icons.star_rounded,
        color: AppColors.starFilled,
      ),
      onRatingUpdate: onRatingChanged ?? (_) {},
    );
  }
}
