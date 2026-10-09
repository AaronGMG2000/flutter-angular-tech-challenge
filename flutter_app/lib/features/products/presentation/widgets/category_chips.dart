import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:catalog/features/products/presentation/providers/category_providers.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: AppSizes.chipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.chipGap),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Builder(
              builder: (chipContext) => ChoiceChip(
                label: Text(AppLang.of(context).categoryAll),
                selected: selected == null,
                onSelected: (_) {
                  ref.read(selectedCategoryProvider.notifier).clear();
                  _centerChip(chipContext);
                },
              ),
            );
          }
          final category = categories[index - 1];
          return _CategoryChip(
            category: category,
            selected: category == selected,
            onSelected: () =>
                ref.read(selectedCategoryProvider.notifier).toggle(category),
          );
        },
      ),
    );
  }
}

void _centerChip(BuildContext chipContext) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!chipContext.mounted) return;
    Scrollable.ensureVisible(
      chipContext,
      alignment: AppLayout.centeredAlignment,
      duration: AppDurations.chipScroll,
      curve: Curves.easeOutCubic,
    );
  });
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onSelected,
  });

  final ProductCategory category;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) {
        onSelected();
        _centerChip(context);
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.ratingGap,
        children: [
          Text(category.name),
          if (selected)
            Icon(
              Icons.close,
              size: AppSizes.chipCloseIcon,
              color: context.colors.onPrimary,
            ),
        ],
      ),
    );
  }
}
