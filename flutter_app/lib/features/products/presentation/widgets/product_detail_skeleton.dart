import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/presentation/widgets/product_detail_layout.dart';
import 'package:flutter/material.dart';

const double _shortLineFactor = 0.6;

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductDetailLayout(
      image: SizedBox.square(
        dimension: AppSizes.inlineSpinner,
        child: CircularProgressIndicator(strokeWidth: AppBorders.spinner),
      ),
      sheet: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sheetGap,
        children: [
          _SkeletonBox(
            width: AppSizes.skeletonTagWidth,
            height: AppSizes.tagHeight,
            radius: AppRadius.pill,
          ),
          _SkeletonBox(height: AppSizes.skeletonTitleHeight),
          _SkeletonBox(height: AppSizes.skeletonLineHeight),
          FractionallySizedBox(
            widthFactor: _shortLineFactor,
            child: _SkeletonBox(height: AppSizes.skeletonLineHeight),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    this.width = double.infinity,
    this.radius = AppRadius.skeletonLine,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.skeleton,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
