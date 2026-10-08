import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/presentation/providers/product_list_provider.dart';
import 'package:catalog/features/products/presentation/providers/search_query_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(searchQueryProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchQueryProvider, (previous, next) {
      if (next.isEmpty && _controller.text.trim().isNotEmpty) {
        _controller.clear();
      }
    });

    final lang = AppLang.of(context);
    final query = ref.watch(searchQueryProvider);
    final isLoading = ref.watch(
      productListProvider.select((products) => products.isLoading),
    );

    return TextField(
      controller: _controller,
      onChanged: ref.read(searchQueryProvider.notifier).change,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: lang.searchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, child) {
            if (query.isNotEmpty && isLoading) return const _SearchSpinner();
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.transparent),
              tooltip: lang.clearSearchTooltip,
              onPressed: _clear,
              icon: const Icon(Icons.cancel),
            );
          },
        ),
      ),
    );
  }
}

class _SearchSpinner extends StatelessWidget {
  const _SearchSpinner();

  @override
  Widget build(BuildContext context) {
    return const Center(
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: SizedBox.square(
          dimension: AppSizes.inlineSpinner,
          child: CircularProgressIndicator(strokeWidth: AppBorders.spinner),
        ),
      ),
    );
  }
}
