import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:catalog/features/products/presentation/screens/product_detail_screen.dart';
import 'package:catalog/features/products/presentation/screens/products_screen.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const String products = '/';
  static const String productDetail = 'products/:id';

  static String product(int id) => '/products/$id';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) => const ProductsScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.productDetail,
            builder: (context, state) => ProductDetailScreen(
              id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
            ),
          ),
        ],
      ),
    ],
  );
}
