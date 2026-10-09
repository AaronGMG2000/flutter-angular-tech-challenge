# Respuestas

## Parte 1 — Preguntas conceptuales

### Dart y Flutter

#### 1. ¿Qué diferencia hay entre `final` y `const` en Dart? ¿Por qué importa usar `const` en constructores de widgets?

#### 2. Explica el null safety de Dart. ¿Cuándo usarías `?`, `!`, `??` y `late`? ¿Por qué abusar de `!` es una mala práctica?

#### 3. ¿Cuál es la diferencia entre `StatelessWidget` y `StatefulWidget`? ¿Qué aportan `ConsumerWidget` y `ConsumerStatefulWidget`?

#### 4. ¿Qué es un `Future` y qué es un `Stream`? Da un caso de uso real de cada uno.

#### 5. ¿Por qué es preferible extraer un widget a una clase propia en lugar de un método `_buildAlgo()` que retorna un `Widget`?

### Riverpod

#### 6. ¿Qué problema resuelve Riverpod frente a `setState` o frente a Provider (el paquete)?

#### 7. Explica la diferencia entre `ref.watch`, `ref.read` y `ref.listen`. ¿Dónde es incorrecto usar `ref.read`?

#### 8. ¿Cuándo usarías un `Provider`, un `FutureProvider`, un `Notifier` y un `AsyncNotifier`?

#### 9. ¿Qué hace el modificador `autoDispose` y qué problema evita? ¿Y `family`?

#### 10. ¿Cómo manejas los estados de carga, error y datos con `AsyncValue`? Escribe un ejemplo con `.when` o pattern matching.

#### 11. ¿Cómo sobrescribirías un provider en un test para inyectar un repositorio falso?

### Angular

#### 12. ¿Qué diferencia hay entre un componente standalone y uno declarado en un `NgModule`?

#### 13. Explica la diferencia entre un Observable (RxJS) y un Signal. ¿Cuándo preferirías cada uno?

#### 14. ¿Para qué sirven `@Input()` / `input()` y `@Output()` / `output()`? ¿Cómo se comunican dos componentes hermanos?

#### 15. ¿Qué es la inyección de dependencias en Angular y para qué sirve `providedIn: 'root'`?

#### 16. ¿Por qué hay que preocuparse por las suscripciones a Observables? Menciona dos formas de evitar fugas de memoria.

### Código limpio y buenas prácticas

#### 17. Explica con tus palabras el principio de responsabilidad única (SRP) y cómo lo aplicarías en una app Flutter.

#### 18. ¿Por qué separar la app en capas (presentación, dominio, datos)? ¿Qué va en cada una?

#### 19. ¿Qué diferencia hay entre una prueba unitaria, una de widget y una de integración?

#### 20. Menciona tres convenciones que sigues al hacer commits y abrir un pull request.

## Parte 4 — Code review

### Fragmento A — Flutter / Riverpod

| #   | Qué está mal | Por qué importa | Cómo lo corregiría |
| --- | ------------ | --------------- | ------------------ |
| 1   |              |                 |                    |

#### Fragmento A reescrito

```dart

```

### Fragmento B — Angular

| #   | Qué está mal | Por qué importa | Cómo lo corregiría |
| --- | ------------ | --------------- | ------------------ |
| 1   |              |                 |                    |
