import 'package:catalog/core/theme/index.dart';
import 'package:flutter/material.dart';

const int _skeletonCount = 9;

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colors.skeleton;

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.gridGap,
        crossAxisSpacing: AppSpacing.gridGap,
        mainAxisExtent: AppSizes.productCardHeight,
      ),
      itemCount: _skeletonCount,
      itemBuilder: (context, index) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );
  }
}
