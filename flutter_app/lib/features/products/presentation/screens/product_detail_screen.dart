import 'package:catalog/core/error/failure.dart';
import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/presentation/providers/product_detail_provider.dart';
import 'package:catalog/features/products/presentation/widgets/product_detail_layout.dart';
import 'package:catalog/features/products/presentation/widgets/product_detail_skeleton.dart';
import 'package:catalog/features/products/presentation/widgets/product_detail_view.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/shared/widgets/state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(productDetailProvider(id));

    return Scaffold(
      body: detail.when(
        skipLoadingOnRefresh: false,
        loading: () => const ProductDetailSkeleton(),
        error: (error, stackTrace) => ProductDetailError(id: id, error: error),
        data: (product) => ProductDetailView(product: product),
      ),
    );
  }
}

class ProductDetailError extends ConsumerWidget {
  const ProductDetailError({required this.id, required this.error, super.key});

  final int id;
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = AppLang.of(context);
    final colors = context.colors;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DetailTopBar(),
          Expanded(
            child: StateView(
              icon: Icons.warning_amber_rounded,
              circleColor: colors.errorSurface,
              iconColor: colors.errorIcon,
              title: lang.productErrorTitle,
              message: error is NotFoundFailure
                  ? lang.productErrorMessage(id)
                  : lang.productsErrorMessage,
              action: Column(
                spacing: AppSpacing.stateActionGap,
                children: [
                  FilledButton.icon(
                    onPressed: () => ref.invalidate(productDetailProvider(id)),
                    icon: const Icon(Icons.refresh),
                    label: Text(lang.retry),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.products),
                    child: Text(lang.backToCatalog),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
