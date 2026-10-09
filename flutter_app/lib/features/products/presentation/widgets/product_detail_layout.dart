import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_badge.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDetailLayout extends StatelessWidget {
  const ProductDetailLayout({
    required this.image,
    required this.sheet,
    super.key,
  });

  final Widget image;
  final Widget sheet;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: colors.imageSurface,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const DetailTopBar(overImage: true),
                  SizedBox(
                    height:
                        AppSizes.detailHeaderHeight + AppSpacing.sheetOverlap,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.sheetOverlap,
                      ),
                      child: Center(child: image),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -AppSpacing.sheetOverlap),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.sheet),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sheetHorizontal,
                  vertical: AppSpacing.sheetVertical,
                ),
                child: sheet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTopBar extends StatelessWidget {
  const DetailTopBar({this.overImage = false, super.key});

  final bool overImage;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.products);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: AppSizes.appBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: AppLang.of(context).back,
              onPressed: () => _back(context),
              icon: const Icon(Icons.arrow_back),
            ),
            const Spacer(),
            CartBadge(
              borderColor: overImage ? colors.imageSurface : colors.background,
            ),
          ],
        ),
      ),
    );
  }
}
