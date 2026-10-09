# Respuestas

Respuestas a la Parte 1 (preguntas conceptuales) y la Parte 4 (code review) de la prueba técnica.

## Parte 1 — Preguntas conceptuales

### Dart y Flutter

#### 1. ¿Qué diferencia hay entre `final` y `const` en Dart? ¿Por qué importa usar `const` en constructores de widgets?

`final` se asigna una sola vez, pero su valor se calcula en tiempo de ejecución. `const` es una constante de compilación: el valor se conoce al compilar, es inmutable en profundidad y Dart reutiliza la misma instancia en todos los lugares donde aparece.

```dart
final now = DateTime.now();
const padding = EdgeInsets.all(16);
const Center(child: CircularProgressIndicator());
```

En los constructores de widgets importa porque un widget `const` se crea una sola vez y Flutter reutiliza esa misma instancia. Cuando el padre se reconstruye, Flutter ve que el widget no cambió y no lo vuelve a construir, lo que ahorra trabajo y mejora el rendimiento.

#### 2. Explica el null safety de Dart. ¿Cuándo usarías `?`, `!`, `??` y `late`? ¿Por qué abusar de `!` es una mala práctica?

Con null safety un tipo no acepta `null`, salvo que nosotros lo indiquemos.

- **`?`** marca un tipo como anulable, por ejemplo `String?`. Lo usamos cuando una variable puede ser `null`.
- **`??`** asigna un valor por defecto: "si esto es `null`, usa esto otro".
- **`!`** le dice al compilador que confiamos en que el valor no será `null`. Hay que usarlo con cuidado: si el valor llega `null`, se produce un error que cierra la app.
- **`late`** declara una variable no nula que se inicializa después, por ejemplo en `initState`.

Abusar de `!` es una mala práctica porque rompe la seguridad que da null safety: si por algún motivo el valor llega `null`, la app lanza un error y se cierra. Es mejor evitarlo con `if` o con patrones que Dart pueda promover, como:

```dart
final items = response.data?['products'] as List<dynamic>? ?? const [];
```

#### 3. ¿Cuál es la diferencia entre `StatelessWidget` y `StatefulWidget`? ¿Qué aportan `ConsumerWidget` y `ConsumerStatefulWidget`?

Un `StatelessWidget` depende únicamente de lo que recibe en el constructor, mientras que un `StatefulWidget` puede tener un estado interno mutable. Esto es útil para estado local de la vista, como un `TextEditingController` o una animación.

- **`ConsumerWidget`** es un `StatelessWidget` que recibe un `WidgetRef` en `build` para leer providers.
- **`ConsumerStatefulWidget`** da acceso a `ref` dentro del `State`. En la app lo utilicé en el buscador, que necesita su controller y a la vez actualiza `searchQueryProvider`.

#### 4. ¿Qué es un `Future` y qué es un `Stream`? Da un caso de uso real de cada uno.

- **`Future`**: representa un único valor que llega más adelante. Por ejemplo, `Future<Product>` devuelve a futuro un valor de tipo `Product`.
- **`Stream`**: es una secuencia de valores en el tiempo a la cual uno se suscribe. Por ejemplo, un stream que notifica los cambios de conectividad del dispositivo o los mensajes de un WebSocket de chat.

#### 5. ¿Por qué es preferible extraer un widget a una clase propia en lugar de un método `_buildAlgo()` que retorna un `Widget`?

Un método `_build…()` es una función que se ejecuta cada vez que el widget padre se reconstruye. En cambio, si creamos una clase propia, el widget solo se reconstruye cuando es necesario y no en cada cambio de estado de la página padre.

### Riverpod

#### 6. ¿Qué problema resuelve Riverpod frente a `setState` o frente a Provider (el paquete)?

- **`setState`** queda atado a un widget: el estado no se comparte entre pantallas y no se puede probar sin montar la UI.
- **Provider** depende del árbol de widgets: si se lee un provider que no está arriba en el árbol, falla en ejecución, y no se pueden tener dos del mismo tipo.

Los providers de Riverpod, en cambio, son declaraciones globales independientes del árbol que el compilador verifica. Además traen estados asíncronos, liberación automática, parámetros y `overrides` para los tests.

#### 7. Explica la diferencia entre `ref.watch`, `ref.read` y `ref.listen`. ¿Dónde es incorrecto usar `ref.read`?

- **`ref.watch`** se suscribe y reconstruye el widget (o recalcula el provider) cuando el valor cambia. Va en `build`.
- **`ref.read`** lee el valor una sola vez sin suscribirse. Se utiliza dentro de callbacks o en métodos de un notifier.
- **`ref.listen`** ejecuta un efecto cuando el valor cambia, sin reconstruir. Sirve, por ejemplo, para mostrar un `SnackBar` o navegar.

No es correcto usar `ref.read` en `build`: solo mostraría el valor inicial y no detectaría cuando el provider cambie.

#### 8. ¿Cuándo usarías un `Provider`, un `FutureProvider`, un `Notifier` y un `AsyncNotifier`?

- **`Provider`**: para valores síncronos que no cambian por acciones del usuario.
- **`FutureProvider`**: una función que devuelve un `Future`, por ejemplo una llamada a una API.
- **`Notifier`**: un objeto que extiende de `NotifierBase` y se usa para cambiar el estado de un provider. No maneja estados asíncronos.
- **`AsyncNotifier`**: un objeto que extiende de `AsyncNotifierBase` y se usa para cambiar el estado de un provider. Maneja estados asíncronos; por ejemplo, el buscador de la app usa un `AsyncNotifier` para manejar el estado de la búsqueda.

#### 9. ¿Qué hace el modificador `autoDispose` y qué problema evita? ¿Y `family`?

- **`autoDispose`** destruye el estado del provider cuando nadie lo escucha, por ejemplo al cerrar la pantalla de detalle. Esto evita que la memoria crezca con datos que ya no se ven.
- **`family`** parametriza un provider, de manera que se pueda acceder a diferentes instancias del mismo provider según el parámetro que se le pase. Por ejemplo, la pantalla de detalle usa un `family` para cargar cada producto según su `id`.

#### 10. ¿Cómo manejas los estados de carga, error y datos con `AsyncValue`? Escribe un ejemplo con `.when` o pattern matching.

`AsyncValue` es una clase sellada con tres casos: `AsyncData`, `AsyncError` y `AsyncLoading`. La pantalla de detalle lo maneja con `.when`:

```dart
final detail = ref.watch(productDetailProvider(id));
return detail.when(
  loading: () => const ProductDetailSkeleton(),
  error: (error, stackTrace) => ProductDetailError(id: id, error: error),
  data: (product) => ProductDetailView(product: product),
);
```

#### 11. ¿Cómo sobrescribirías un provider en un test para inyectar un repositorio falso?

Se crea un `ProviderContainer` (o un `ProviderScope` en un test de widget) con `overrides`. Todo provider que dependa del repositorio recibe el falso sin cambiar código de producción.

```dart
final container = ProviderContainer.test(
  overrides: [
    productRepositoryProvider.overrideWithValue(FakeProductRepository()),
  ],
);
final page = await container.read(productListProvider.future);
```

### Angular

#### 12. ¿Qué diferencia hay entre un componente standalone y uno declarado en un `NgModule`?

Un componente **standalone** declara sus propias dependencias en `imports` dentro de `@Component` y no pertenece a ningún módulo. Un componente declarado en un **`NgModule`** debe estar en el arreglo `declarations` de ese módulo y recibe lo que el módulo importe, así que sus dependencias no se ven en el componente.

#### 13. Explica la diferencia entre un Observable (RxJS) y un Signal. ¿Cuándo preferirías cada uno?

- **Observable**: es un flujo de valores en el tiempo. Es perezoso, hay que suscribirse y tiene operadores para combinar, cancelar o reintentar.
- **Signal**: es un valor reactivo síncrono que siempre tiene un valor actual. Se lee llamándolo y Angular sabe exactamente qué vista actualizar.

Preferiría un Observable para manejar eventos que pasan en el tiempo, como peticiones HTTP o datos que llegan de forma asíncrona. Un signal lo preferiría para el estado de la vista, como un filtro o un valor que se muestra en pantalla.

#### 14. ¿Para qué sirven `@Input()` / `input()` y `@Output()` / `output()`? ¿Cómo se comunican dos componentes hermanos?

`input()` pasa datos del padre al hijo y `output()` emite eventos del hijo al padre. Dos hermanos se comunican a través del padre común o, si el estado es compartido por varias vistas, con un servicio que expone un signal o un Observable.

#### 15. ¿Qué es la inyección de dependencias en Angular y para qué sirve `providedIn: 'root'`?

La inyección de dependencias es una forma de pasar dependencias a un componente, servicio o directiva sin tener que crearlas dentro de él.

`providedIn: 'root'` hace que el servicio sea un singleton disponible en toda la aplicación. Si en lugar de eso el servicio se declara en los `providers` de un componente, solo vive mientras ese componente está en memoria y desaparece cuando se destruye.

#### 16. ¿Por qué hay que preocuparse por las suscripciones a Observables? Menciona dos formas de evitar fugas de memoria.

Si el Observable no termina, la suscripción sigue viva aunque el componente se destruya: se acumula memoria, se repiten peticiones y el callback toca un componente que ya no existe. Para evitarlo:

1. Dejar que Angular se suscriba y desuscriba: `async` pipe en la plantilla, `toSignal` o `rxResource`.
2. Si hace falta `subscribe()`, cortar la suscripción con `takeUntilDestroyed()`.

### Código limpio y buenas prácticas

#### 17. Explica con tus palabras el principio de responsabilidad única (SRP) y cómo lo aplicarías en una app Flutter.

El principio de responsabilidad única dice que una clase debe tener un solo motivo para cambiar. Por ejemplo, dentro de la app:

- el widget solo dibuja,
- el notifier decide el estado,
- el repositorio obtiene y convierte los datos,
- el DTO sabe leer el JSON.

Como los cambios en la UI no afectan al repositorio y los cambios en la API no afectan a la UI, cada capa se puede modificar de forma aislada sin romper el resto de la app.

#### 18. ¿Por qué separar la app en capas (presentación, dominio, datos)? ¿Qué va en cada una?

Para que cada parte cambie y se pruebe sin arrastrar a las demás.

| Capa             | Qué contiene                                                                                                       |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Presentación** | Pantallas, widgets y providers que adaptan el estado a la vista                                                    |
| **Dominio**      | Entidades y contratos de repositorio, en Dart puro, sin Flutter ni Dio                                             |
| **Datos**        | DTOs, data source con Dio e implementación del repositorio, que traduce JSON a entidades y excepciones a `Failure` |

Las dependencias apuntan hacia el dominio, y por eso en los tests basta con un repositorio falso.

#### 19. ¿Qué diferencia hay entre una prueba unitaria, una de widget y una de integración?

| Tipo               | Qué prueba                                                                                                                   |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| **Unitaria**       | Una clase o función aislada, sin UI                                                                                          |
| **De widget**      | Monta un widget en un entorno de prueba sin dispositivo, lo toca con `tester` y revisa lo que se ve, con dependencias falsas |
| **De integración** | Corre la app completa en un dispositivo o emulador con `integration_test`. Es la más realista y la más lenta                 |

#### 20. Menciona tres convenciones que sigues al hacer commits y abrir un pull request.

1. **Conventional Commits con alcance y en imperativo**, por ejemplo `feat(cart): persist cart in shared preferences`.
2. **Commits pequeños y atómicos**: cada uno compila y deja los tests en verde, y separo funcionalidad, tests y formato.
3. **Un PR por objetivo**, con descripción de qué cambia, por qué y cómo probarlo, capturas si es UI y CI en verde antes de pedir revisión.

## Parte 4 — Code review

Cada observación indica qué está mal, por qué importa y cómo lo corregiría.

### Fragmento A — Flutter / Riverpod

#### 1. Petición HTTP dentro de `build`

- **Problema:** hay un `http.get` dentro de `build`.
- **Por qué importa:** `build` se ejecuta con cada cambio en el widget y cada ejecución hace una nueva petición HTTP. Además, el `setState` de la respuesta vuelve a llamar a `build`, lo que genera un ciclo de peticiones y un consumo excesivo de recursos.
- **Corrección:** mover la carga a un `FutureProvider` y que `build` solo haga `ref.watch` del resultado.

#### 2. El widget accede directamente a HTTP

- **Problema:** de acuerdo con el principio SRP, el widget no debería tener acceso a `http.get`.
- **Por qué importa:** mezcla red y vista, y complica probar el widget, porque no se puede reemplazar la API por un repositorio falso.
- **Corrección:** crear un repositorio inyectado con un provider; la pantalla solo consume el provider.

#### 3. `setState` para estado de negocio

- **Problema:** se utiliza `setState` para guardar los productos y el estado de carga.
- **Por qué importa:** según las reglas de la prueba, el estado de negocio debe manejarse con Riverpod.
- **Corrección:** usar el `AsyncValue` del provider, que ya trae los estados de carga, error y datos.

#### 4. Sin manejo de errores

- **Problema:** no existe ningún manejo de errores si `http.get` falla.
- **Por qué importa:** no se muestra ningún mensaje al usuario y la app se queda en la pantalla de carga para siempre.
- **Corrección:** mostrar el caso `AsyncError` con un botón de reintentar (`ref.invalidate`).

#### 5. Sin modelo inmutable

- **Problema:** no se utiliza un modelo inmutable; todo es `dynamic` (`List data`, `List<Map>`, `p['title']`).
- **Por qué importa:** un campo mal escrito o nulo hace explotar la ejecución, y el compilador no puede ayudar.
- **Corrección:** un modelo `Product` inmutable con `fromJson`.

#### 6. `ref.read` en `build`

- **Problema:** se utiliza `ref.read(cartProvider)` en `build` para mostrar el contador.
- **Por qué importa:** `ref.read` no se suscribe, así que el contador del `AppBar` nunca se actualiza.
- **Corrección:** usar `ref.watch` en `build` y dejar `ref.read` solo para callbacks.

#### 7. Se muta el estado del carrito

- **Problema:** se utiliza `ref.read(cartProvider).add(p)` para modificar el estado en lugar de un `Notifier`.
- **Por qué importa:** se modifica la lista existente; el provider no cambia de referencia, nadie se entera del cambio y el estado deja de ser inmutable.
- **Corrección:** un `Notifier` con un método `add` que crea una lista nueva (`[...state, product]`).

#### 8. Código de depuración

- **Problema:** tiene un `print('agregado')`.
- **Por qué importa:** es código de depuración que no debe llegar a producción.
- **Corrección:** eliminarlo; si se quiere avisar al usuario, mostrar un `SnackBar`.

#### 9. Spinner fuera del `Scaffold`

- **Problema:** mientras carga se retorna `CircularProgressIndicator()` solo, sin `Scaffold` ni `const`.
- **Por qué importa:** la pantalla de carga pierde el `AppBar` y el indicador queda pegado en la esquina superior.
- **Corrección:** mostrar el indicador centrado dentro del mismo `Scaffold`, como `const`.

#### 10. Lista sin construcción perezosa

- **Problema:** `ListView(children: data.map(...).toList())`.
- **Por qué importa:** construye todos los elementos aunque no estén en pantalla.
- **Corrección:** `ListView.builder`.

#### 11. Declaración del provider y del widget

- **Problema:** el provider se declara con `var` y `StateProvider`, y `ProductsScreen` no tiene constructor `const` ni `key`.
- **Por qué importa:** `var` permite reasignar el provider global, `StateProvider` es legacy en Riverpod 3 y sin `const` el widget se reconstruye de más.
- **Corrección:** `final` + `NotifierProvider`, y `const ProductsScreen({super.key})`. Con `ConsumerWidget` ya no hace falta un `State`.

#### Fragmento A reescrito

`Product` (modelo inmutable con `fromJson`) y `productRepositoryProvider` viven en sus capas de datos y dominio; aquí solo está la pantalla y su estado.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = FutureProvider.autoDispose<List<Product>>(
  (ref) => ref.watch(productRepositoryProvider).fetchProducts(),
);

class CartNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() => const [];

  void add(Product product) => state = [...state, product];
}

final cartProvider = NotifierProvider<CartNotifier, List<Product>>(
  CartNotifier.new,
);

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final cartCount = ref.watch(cartProvider).length;

    return Scaffold(
      appBar: AppBar(title: Text('Productos ($cartCount)')),
      body: switch (products) {
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final product = value[index];
            return ListTile(
              title: Text(product.title),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              onTap: () => ref.read(cartProvider.notifier).add(product),
            );
          },
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(productsProvider),
            child: const Text('Reintentar'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
```

### Fragmento B — Angular

#### 1. `setInterval` nunca se limpia

- **Problema:** el `setInterval` de `ngOnInit` no se cancela nunca.
- **Por qué importa:** al salir de la vista sigue pidiendo `/carts` cada 5 segundos para siempre: fuga de memoria y tráfico innecesario.
- **Corrección:** usar `timer` de RxJS convertido con `toSignal`, que se desuscribe solo al destruir el componente.

#### 2. Suscripciones sin cancelar en cada intervalo

- **Problema:** cada 5 segundos se hace un `subscribe()` nuevo que nadie cancela.
- **Por qué importa:** si una respuesta tarda más de 5 segundos, se acumulan peticiones y pueden llegar fuera de orden.
- **Corrección:** `switchMap`, que cancela la petición anterior cuando empieza la siguiente.

#### 3. La primera carga espera 5 segundos

- **Problema:** el primer `get` ocurre recién cuando se cumple el primer intervalo.
- **Por qué importa:** la pantalla arranca vacía durante 5 segundos.
- **Corrección:** `timer(0, 5000)`, que emite de inmediato y luego cada 5 segundos.

#### 4. Uso de `any`

- **Problema:** `orders: any` y `(r: any)`.
- **Por qué importa:** se pierde el tipado estricto; un error en `r.carts` no se detecta al compilar.
- **Corrección:** interfaces `Cart` y `CartsResponse`.

#### 5. `HttpClient` dentro del componente

- **Problema:** el componente llama directamente a `HttpClient`.
- **Por qué importa:** mezcla datos y vista, y la lógica no se puede reutilizar ni probar por separado.
- **Corrección:** un `OrdersService` con `providedIn: 'root'` que el componente obtiene con `inject()`.

#### 6. `*ngFor` sin importar en un componente standalone

- **Problema:** la plantilla usa `*ngFor`, pero el componente no importa `NgFor`.
- **Por qué importa:** en un componente standalone la directiva no está disponible y la lista no se renderiza.
- **Corrección:** usar el control flow `@for` con `track order.id`, que además evita recrear toda la lista en cada actualización.

#### 7. Sin estados de carga ni de error

- **Problema:** no se maneja el error del `subscribe` ni se muestra un estado de carga.
- **Por qué importa:** si la petición falla, el usuario no ve nada y no sabe qué pasó.
- **Corrección:** capturar el error con `catchError` y mostrar un mensaje en la plantilla.

#### 8. Estado en un campo normal

- **Problema:** se asigna `this.orders = r.carts` en un campo normal.
- **Por qué importa:** en una app zoneless (como la de este repositorio, con Angular 22) asignar un campo no dispara la detección de cambios y la vista no se actualiza.
- **Corrección:** exponer el estado como signal.

#### Fragmento B corregido

```ts
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import { catchError, map, of, switchMap, timer } from 'rxjs';
import { Cart } from '../core/models/order.model';
import { OrdersService } from '../core/services/orders.service';

const POLL_INTERVAL_MS = 5000;

interface OrdersState {
  orders: Cart[];
  failed: boolean;
}

@Component({
  selector: 'app-orders',
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (state().failed) {
      <p>No pudimos actualizar los pedidos.</p>
    }
    @for (order of state().orders; track order.id) {
      <div>{{ order.total }}</div>
    }
  `,
})
export class OrdersComponent {
  private readonly ordersService = inject(OrdersService);

  readonly state = toSignal(
    timer(0, POLL_INTERVAL_MS).pipe(
      switchMap(() =>
        this.ordersService.getOrders().pipe(
          map((orders): OrdersState => ({ orders, failed: false })),
          catchError(() => of<OrdersState>({ orders: [], failed: true })),
        ),
      ),
    ),
    { initialValue: { orders: [], failed: false } satisfies OrdersState },
  );
}
```
