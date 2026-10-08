import 'package:catalog/core/theme/index.dart';
import 'package:flutter/material.dart';

const int _skeletonCount = 4;

class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colors.skeleton;

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _skeletonCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.listGap),
      itemBuilder: (context, index) => Container(
        height: AppSizes.listTileSkeletonHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );
  }
}
