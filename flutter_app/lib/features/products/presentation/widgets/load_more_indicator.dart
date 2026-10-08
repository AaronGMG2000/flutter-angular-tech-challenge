import 'package:catalog/core/theme/index.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';

class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator({
    required this.loaded,
    required this.total,
    super.key,
  });

  final int loaded;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final skeleton = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.skeleton,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.gridGap),
      child: Column(
        children: [
          SizedBox(
            height: AppSizes.loadMoreSkeletonHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.gridGap,
              children: [
                Expanded(child: skeleton),
                Expanded(child: skeleton),
              ],
            ),
          ),
          SizedBox(
            height: AppSizes.loadMoreRowHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSpacing.inlineGap,
              children: [
                const SizedBox.square(
                  dimension: AppSizes.inlineSpinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppBorders.spinner,
                  ),
                ),
                Text(
                  AppLang.of(context).loadingMore(loaded, total),
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
