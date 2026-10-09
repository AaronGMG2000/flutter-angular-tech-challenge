# Prueba técnica · Flutter (Riverpod) + Angular

[![CI](https://github.com/AaronGMG2000/flutter-angular-tech-challenge/actions/workflows/ci.yml/badge.svg)](https://github.com/AaronGMG2000/flutter-angular-tech-challenge/actions/workflows/ci.yml)

Dos aplicaciones sobre la API pública de [DummyJSON](https://dummyjson.com):

| Carpeta | Parte | Qué es | Stack |
|---|---|---|---|
| [`flutter_app/`](flutter_app) | 2 | Mini catálogo móvil: listado paginado, búsqueda con debounce, categorías, detalle, carrito y tema oscuro | Flutter 3.47 · Riverpod 3 · go_router · Dio · freezed |
| [`angular_app/`](angular_app) | 3 | Panel web de pedidos: listado con filtro reactivo, detalle lazy y tema oscuro | Angular 22 standalone · signals · Tailwind 4 · Vitest |

Las respuestas de las Partes 1 y 4 están en [RESPUESTAS.md](RESPUESTAS.md).

## Cómo correrlo

### Flutter

Requisitos: Flutter 3.47 (stable).

```bash
cd flutter_app
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Los archivos generados (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_lang*.dart`) no se versionan: hay que correr los dos generadores después de clonar.

Tests y análisis:

```bash
flutter analyze
flutter test --coverage
```

### Angular

Requisitos: Node 24 y pnpm (`corepack enable`).

```bash
cd angular_app
pnpm install
pnpm start          # http://localhost:4200
```

Tests, lint y build:

```bash
pnpm lint
pnpm test --watch=false
pnpm build
```

## Flutter · arquitectura

```
lib/
  core/        error (Failure sellada, mapper de Dio, guardRequest, retryPolicy),
               network (Dio), router (go_router), storage, theme (tokens + AppTheme), utils
  features/
    products/  data (DTOs, datasource, repositorio) · domain (entidades, contrato)
               presentation (providers, screens, widgets)
    cart/      data (persistencia) · domain (CartItem, CartState) · presentation
  shared/      widgets reutilizados por varias features
  l10n/        textos en app_es.arb
```

Providers principales:

| Provider | Tipo | Para qué |
|---|---|---|
| `productRepositoryProvider` | `Provider<ProductRepository>` | Único override en los tests |
| `productListProvider` | `AsyncNotifier<ProductPage>` | Listado; escucha búsqueda y categoría; `loadMore()` |
| `searchQueryProvider` | `Notifier<String>` | Texto del buscador; el debounce de 400 ms vive en el listado |
| `selectedCategoryProvider` · `categoriesProvider` | `Notifier` · `FutureProvider` | Chips de categoría |
| `productDetailProvider(id)` | `FutureProvider.autoDispose.family` | Detalle |
| `cartProvider` | `Notifier<CartState>` (keepAlive) | Carrito inmutable y persistido |
| `themeModeProvider` | `Notifier<ThemeMode>` (keepAlive) | Claro / oscuro persistido |

### Decisiones

- **Modelos con freezed + json_serializable.** Las entidades (`Product`, `ProductPage`, `CartItem`, `CartState`) y los DTOs son inmutables con `copyWith`, `==` y `hashCode` generados; los DTOs además traen `fromJson`. Escribirlo a mano son decenas de líneas por clase donde es fácil olvidar un campo en `==`. El DTO se separa de la entidad y se convierte con `toEntity()`, así la forma del JSON no llega a la UI.
- **Errores tipados.** Toda excepción de red se convierte en una `Failure` sellada (`NetworkFailure`, `NotFoundFailure`, `ServerFailure`…) dentro del repositorio. La UI distingue un 404 de un problema de conexión con un `switch` exhaustivo. Los errores de red y 5xx se reintentan dos veces con backoff; un 404 no.
- **Búsqueda + categoría.** DummyJSON no filtra por texto y categoría a la vez. Con texto se pide `/products/search?q=…&limit=0` (todos los resultados, son pocos) y, si hay categoría, se filtra en el cliente por `product.category`. Sin texto, la categoría usa `/products/category/{slug}` con paginación normal.
- **Debounce sin Timer.** `ProductList.build()` espera 400 ms cuando hay texto. Si llega otra letra, Riverpod descarta ese build y empieza otro. La cancelación se detecta con `ref.onDispose` y no con `ref.mounted`: en un `Notifier`, `ref` siempre apunta al Ref actual y `mounted` sigue en `true` después de un rebuild.
- **Carrito.** Cada acción crea una lista nueva. Se persiste en `shared_preferences` escuchando el propio estado (`listenSelf`), así ninguna acción tiene que acordarse de guardar.
- **Tema.** `AppTheme.light` y `AppTheme.dark` se arman desde la misma función con dos paletas. Los widgets leen colores de una `ThemeExtension` (`context.colors`) y `themeModeProvider` decide cuál se usa.

### Tests

57 tests (unitarios y de widgets), cobertura cercana al 96 % sin contar archivos generados. Los pedidos por la prueba:

- Unitarios: `cart_provider_test.dart`, `product_list_provider_test.dart`, `product_repository_impl_test.dart`, `dio_failure_mapper_test.dart`.
- Widget: `products_screen_test.dart` y `flows/shopping_flow_test.dart` (buscar, agregar, detalle, carrito con la app real).

## Angular · arquitectura

```
src/app/
  core/models/order.model.ts        Cart, CartProduct, CartsResponse
  core/services/orders.service.ts   HttpClient, providedIn: 'root'
  core/services/theme.service.ts    signal + effect → data-theme (extra)
  shared/pipes/                     discount ("-10,5 %") y money ("$1.099,99")
  shared/ui/error-banner/           banner de error reutilizado en listado y detalle
  features/orders/
    orders-page/                    contenedor: rxResource + signals de filtro + computed
    order-card/                     presentacional: input(), output(viewDetail), OnPush
    order-detail/                   ruta lazy /orders/:id, id como input()
```

### Decisiones

- **Sin `subscribe()` manuales.** Los datos se cargan con `rxResource`, que expone `value()`, `isLoading()`, `error()` y `reload()` como signals. Es la evolución de `toSignal` con los estados de carga y error incluidos.
- **Filtro.** `minTotal` y `userId` son `signal<number | null>`; `filtered` es un `computed`. Se compara contra `discountedTotal`.
- **Detalle lazy.** `loadComponent` en `/orders/:id`; el id llega como `input()` gracias a `withComponentInputBinding()`.
- **Estilos.** Los tokens del diseño son variables CSS conectadas a Tailwind 4 con `@theme inline`. El tema oscuro solo redefine las variables.
- **Formato es-CL.** `LOCALE_ID` y datos de locale registrados: miles con punto y decimales con coma.

19 tests con Vitest: servicio, pipes, card, página, detalle y tema.

## Extras

- Tema oscuro en el panel web (2f–2j), no pedido en la Parte 3.
- Carrito persistido y tema persistido en Flutter.
- Scroll infinito con descarte de páginas tardías al cambiar de filtro.
- CI en GitHub Actions para las dos apps en cada push (`.github/workflows/ci.yml`): format, analyze/lint, tests y build.

## Flutter ↔ Angular

| Flutter | Angular |
|---|---|
| `ProductRepository` + `productRepositoryProvider` | `OrdersService` con `providedIn: 'root'` |
| Provider / `AsyncNotifier` (`AsyncValue`) | `signal` / `computed` / `rxResource` (`value`, `isLoading`, `error`) |
| `ref.watch` en `build` | leer un signal en la plantilla |
| Widget sin estado que recibe datos y callbacks | Componente presentacional con `input()` / `output()` y `OnPush` |
| `overrides` en `ProviderScope` / `ProviderContainer` | `providers` en `TestBed` + `HttpTestingController` |
| `go_router` con `/products/:id` | `loadComponent` en `/orders/:id` |

## Pendientes

- El flujo "buscar → detalle → carrito" se prueba como test de widget con la app completa (`test/flows/shopping_flow_test.dart`), no con `integration_test` en un dispositivo.
- El panel web no tiene tests end-to-end.

## Con más tiempo

- Paginación del lado del servidor para búsqueda y categoría juntas (requiere un backend propio).
- Tests en dispositivo con `integration_test` y golden tests del tema oscuro.
- Caché HTTP con expiración para el detalle de producto.
- Internacionalización real en Angular con `@angular/localize`.
