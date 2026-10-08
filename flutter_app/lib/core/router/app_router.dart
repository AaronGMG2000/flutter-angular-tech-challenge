import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:catalog/features/products/presentation/screens/products_screen.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const String products = '/';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) => const ProductsScreen(),
      ),
    ],
  );
}
