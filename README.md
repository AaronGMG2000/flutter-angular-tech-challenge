# Mini Catálogo · Panel de Pedidos

[![CI](https://github.com/AaronGMG2000/flutter-angular-tech-challenge/actions/workflows/ci.yml/badge.svg)](https://github.com/AaronGMG2000/flutter-angular-tech-challenge/actions/workflows/ci.yml)

Prueba técnica para desarrollador Flutter (Riverpod) + Angular. Contiene dos aplicaciones independientes que consumen la API pública de [DummyJSON](https://dummyjson.com):

| Aplicación | Parte | Descripción | Stack principal |
|---|---|---|---|
| [`flutter_app/`](flutter_app) | 2 | Catálogo móvil con listado paginado, búsqueda, filtro por categoría, detalle y carrito persistente | Flutter 3.47 · Riverpod 3 · go_router · Dio · freezed |
| [`angular_app/`](angular_app) | 3 | Panel web de pedidos con filtro reactivo y detalle por pedido | Angular 22 · signals · RxJS · Tailwind CSS 4 · Vitest |

Las respuestas de las Partes 1 (preguntas conceptuales) y 4 (code review) están en [`RESPUESTAS.md`](RESPUESTAS.md).

## Cómo ejecutar

### Flutter

Requisitos: Flutter 3.47 (canal stable).

```bash
cd flutter_app
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter run
```

El código generado (`*.g.dart`, `*.freezed.dart`, `*.g.theme.dart` y `lib/l10n/app_lang*.dart`) no se versiona, por eso los dos generadores deben correr después de clonar.

```bash
flutter analyze
flutter test --coverage
```

### Angular

Requisitos: Node 24 y pnpm (`corepack enable`).

```bash
cd angular_app
pnpm install
pnpm start            # http://localhost:4200
```

```bash
pnpm lint
pnpm test --watch=false
pnpm build
```

Una GitHub Action ([`ci.yml`](.github/workflows/ci.yml)) corre estos mismos comandos para las dos apps en cada push.

## Decisiones de arquitectura

### Flutter

La app sigue una **arquitectura por capas organizada por feature** (Clean Architecture simplificada). Cada feature (`products`, `cart`) se divide en tres capas y las dependencias apuntan siempre hacia el dominio:

| Capa | Contiene | Depende de |
|---|---|---|
| **Presentación** | Pantallas, widgets y providers de Riverpod que adaptan el estado a la vista | Dominio |
| **Dominio** | Entidades inmutables (`Product`, `ProductPage`, `CartItem`, `CartState`) y contratos (`ProductRepository`, `CartStorage`). Dart puro, sin Flutter ni Dio | Nada |
| **Datos** | DTOs con `fromJson`, data sources (Dio, `shared_preferences`) e implementaciones de los contratos | Dominio |

Reglas que se cumplen en todo el proyecto:

- La UI nunca importa Dio: obtiene el repositorio con `ref.watch(productRepositoryProvider)`, que es además el único punto que se sobrescribe en los tests.
- Los DTOs no salen de la capa de datos. Cada uno se convierte a entidad con una extensión `toEntity()`, así un cambio en el JSON no toca la UI.
- Ninguna excepción cruda llega a la pantalla: el repositorio envuelve cada llamada en `guardRequest`, que traduce `DioException` a una `Failure` tipada.

#### Estructura

```
lib/
├── main.dart                        ProviderScope con política de reintentos
├── app.dart                         MaterialApp.router: tema, idioma y router
├── core/
│   ├── constants/api_constants.dart URL base, tamaño de página, debounce (400 ms)
│   ├── error/
│   │   ├── failure.dart             Failure sellada: Network, Timeout, NotFound, Server, Parse…
│   │   ├── dio_failure_mapper.dart  DioException → Failure
│   │   ├── guard_request.dart       Envuelve cada llamada del repositorio
│   │   └── retry_policy.dart        Reintenta red, timeout y 5xx; nunca un 404
│   ├── network/dio_provider.dart    Cliente Dio con base URL y timeouts
│   ├── router/app_router.dart       go_router: /, /products/:id, /cart
│   ├── storage/preferences_provider.dart
│   ├── theme/                       Tokens (colores, espaciados, tipografía), AppTheme
│   │                                claro/oscuro y themeModeProvider persistido
│   └── utils/app_formats.dart       Formato de precio, rating y descuento
├── features/
│   ├── products/
│   │   ├── data/
│   │   │   ├── datasources/product_remote_data_source.dart
│   │   │   ├── models/              ProductDto, ProductsResponseDto, ProductCategoryDto
│   │   │   └── repositories/product_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/            Product, ProductPage, ProductCategory
│   │   │   └── repositories/product_repository.dart
│   │   └── presentation/
│   │       ├── providers/           productList, searchQuery, categorías, detalle,
│   │       │                        cantidad del detalle
│   │       ├── screens/             ProductsScreen, ProductDetailScreen
│   │       └── widgets/             grilla, lista de resultados, card, chips, buscador,
│   │                                skeletons, indicador de más resultados, detalle
│   └── cart/
│       ├── data/                    CartItemDto y SharedPrefsCartStorage
│       ├── domain/                  CartItem, CartState, contrato CartStorage
│       └── presentation/            cartProvider, CartScreen, badge, ítem, resumen,
│                                    snackbar y marca "en el carrito"
├── shared/widgets/                  QuantityStepper, StateView (vacío/error), ThemeToggleButton
└── l10n/app_es.arb                  Textos de la UI (clase generada AppLang)

test/
├── core/                            mapper de errores, tema
├── features/                        datos, providers y pantallas de cada feature
├── flows/shopping_flow_test.dart    buscar → detalle → agregar → carrito con la app completa
└── flutter_test_config.dart         shared_preferences en memoria para todos los tests
```

#### Gestión de estado

Todo el estado de negocio vive en providers generados con `riverpod_generator`. `setState` no se usa para estado de negocio; el único estado local es el `TextEditingController` del buscador.

| Provider | Tipo | Responsabilidad |
|---|---|---|
| `productRepositoryProvider` | `Provider<ProductRepository>` | Inyecta el repositorio; se sobrescribe en los tests |
| `productListProvider` | `AsyncNotifier<ProductPage>` | Listado: combina búsqueda y categoría, aplica el debounce y expone `loadMore()` |
| `searchQueryProvider` | `Notifier<String>` | Texto del buscador |
| `selectedCategoryProvider` | `Notifier<ProductCategory?>` | Categoría elegida |
| `categoriesProvider` | `FutureProvider` | Lista de categorías |
| `productDetailProvider(id)` | `FutureProvider` con `family` | Detalle por id; se libera al salir de la pantalla |
| `cartProvider` | `Notifier<CartState>` (`keepAlive`) | Carrito inmutable: agregar, cambiar cantidad, quitar, vaciar |
| `themeModeProvider` | `Notifier<ThemeMode>` (`keepAlive`) | Tema claro/oscuro persistido |

#### Decisiones técnicas

- **freezed + json_serializable para los modelos.** Generan `copyWith`, igualdad por valor, `hashCode` y `fromJson`. Escribirlo a mano son decenas de líneas por clase, y olvidar un campo en `==` rompe la detección de cambios de Riverpod sin ningún aviso. La igualdad por valor es la que permite comparar estados del carrito.
- **Errores tipados.** El repositorio convierte toda excepción de Dio en una `Failure` sellada (`NetworkFailure`, `NotFoundFailure`, `ServerFailure`…), así la UI nunca recibe una excepción cruda y el detalle distingue "producto no encontrado" de un error de conexión. La política de reintentos del `ProviderScope` repite dos veces los errores de red y 5xx con espera creciente.
- **Debounce sin `Timer`.** `ProductList.build()` espera 400 ms cuando hay texto. Si llega otra letra, Riverpod descarta ese build y empieza otro; la cancelación se detecta con `ref.onDispose`, así que solo la última búsqueda llega a la red.
- **Búsqueda combinada con categoría.** DummyJSON no filtra por texto y categoría en la misma llamada. Con texto se piden todos los resultados de `/products/search` (son pocos) y se filtra la categoría en el cliente; sin texto se usa `/products/category/{slug}` con paginación.
- **Scroll infinito.** `loadMore()` agrega la página siguiente a la lista existente. Si el usuario cambia el filtro mientras carga, la respuesta tardía se descarta.
- **Carrito persistente.** Cada acción crea una lista nueva. El notifier se guarda a sí mismo con `listenSelf` en `shared_preferences`, así ninguna acción tiene que acordarse de persistir. El botón del carrito (`CartBadge`) muestra el total y la cantidad de productos en la barra superior del listado, del detalle y del carrito.
- **Diseño con tokens.** Colores en una `ThemeExtension` generada con `theme_extensions_builder` (`context.colors`) y medidas en constantes (`AppSpacing`, `AppSizes`, `AppLayout`); los widgets no tienen valores sueltos.
- **Textos con `gen-l10n`.** Todos los textos visibles están en `app_es.arb`.

### Angular

Aplicación standalone con TypeScript `strict` y plantillas estrictas, sin `NgModule` ni `zone.js`. La separación replica la de Flutter: un **servicio** concentra el acceso HTTP, un **componente contenedor** maneja el estado y **componentes presentacionales** solo dibujan.

#### Estructura

```
src/app/
├── app.config.ts                    HttpClient, router con input binding, locale es-CL
├── app.routes.ts                    /orders con carga diferida
├── app.ts · app.html                Barra superior fija y router-outlet
├── core/
│   ├── config/api.config.ts         InjectionToken API_BASE_URL
│   ├── models/order.model.ts        Cart, CartProduct, CartsResponse
│   └── services/
│       ├── orders.service.ts        HttpClient tipado, providedIn: 'root'
│       └── theme.service.ts         Tema claro/oscuro con signal + effect
├── features/orders/
│   ├── orders.routes.ts             '' → listado, ':id' → detalle (loadComponent)
│   ├── orders-page/                 Contenedor: carga, filtro y estados
│   ├── order-card/                  Presentacional: input(), output(), OnPush
│   └── order-detail/                Detalle con KPIs, tabla de productos y estado "no encontrado"
├── shared/
│   ├── pipes/                       money ($1.099,99) y discount (-10,5 %)
│   └── ui/error-banner/             Banner de error reutilizable
└── testing/orders.fixtures.ts       Datos de prueba
```

#### Estado y flujo de datos

- `OrdersService` devuelve `Observable<Cart[]>` y `Observable<Cart>`. Ningún componente usa `HttpClient`.
- `OrdersPageComponent` carga con `rxResource`, que expone `value()`, `isLoading()`, `error()` y `reload()` como signals y se desuscribe solo. No hay ningún `subscribe()` manual en la app.
- El filtro son dos signals (`minTotal`, `userId`) y la lista visible es un `computed`. Se puede combinar total mínimo con usuario. El total mínimo se compara con el total con descuento (`discountedTotal`), que es el precio que muestra cada tarjeta.
- El detalle recibe el `id` de la ruta como `input()` gracias a `withComponentInputBinding()` y vuelve a cargar cuando cambia.
- Los componentes presentacionales usan `ChangeDetectionStrategy.OnPush` y el nuevo control flow (`@if`, `@for` con `track`).

#### Decisiones técnicas

- **`rxResource` en lugar de `toSignal`.** Da los estados de carga y error sin código extra y permite reintentar con `reload()`.
- **Tailwind 4 sobre variables CSS.** Los tokens del diseño son variables CSS conectadas a Tailwind con `@theme inline`; el tema oscuro solo redefine las variables.
- **Locale es-CL.** Moneda con punto de miles y coma decimal, igual que en la app móvil.

### Paralelos Flutter ↔ Angular

| Concepto | Flutter | Angular |
|---|---|---|
| Servicio ≈ repositorio | `ProductRepository` inyectado con un provider | `OrdersService` con `providedIn: 'root'` |
| Signal / Observable ≈ provider | Providers de Riverpod que exponen estado | `signal`, `computed` y Observables del servicio |
| Estado asíncrono | `AsyncNotifier` / `FutureProvider` → `AsyncValue` | `rxResource` → `value`, `isLoading`, `error` |
| Estado derivado | Provider que hace `ref.watch` de otros | `computed` |
| Suscripción en la vista | `ref.watch` en `build` | leer un signal en la plantilla |
| Componente presentacional ≈ widget sin estado | Widget que recibe datos y callbacks | Componente presentacional con `input()` / `output()` y `OnPush` |
| Inyección en tests | `overrides` en `ProviderContainer` / `ProviderScope` | `providers` en `TestBed` + `HttpTestingController` |
| Navegación | `go_router`, `/products/:id` | Router con `loadComponent`, `/orders/:id` |

## Qué quedó pendiente

- El flujo "buscar → detalle → agregar al carrito" se prueba como test de widget con la app completa (`test/flows/shopping_flow_test.dart`), no con `integration_test` en un dispositivo.
- Si falla la carga de la página siguiente en el scroll infinito, el error no se muestra: se reintenta al volver a llegar al final de la lista.
- El panel web no tiene pruebas end-to-end.

## Qué mejoraría con más tiempo

- Pruebas en dispositivo con `integration_test` y golden tests del tema oscuro.
- Caché HTTP con expiración para el detalle de producto.
- Paginación del lado del servidor para búsqueda y categoría combinadas (requiere un backend propio).
- Pruebas end-to-end del panel web con Playwright.
- Internacionalización del panel web con `@angular/localize`.
