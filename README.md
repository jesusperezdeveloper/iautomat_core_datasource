# iAut Core DataSource

**Contratos puros para data sources desacoplados en Flutter/Dart**

[![CI](https://github.com/tu-org/iaut_core_datasource/workflows/CI/badge.svg)](https://github.com/tu-org/iaut_core_datasource/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Este paquete proporciona tipos, interfaces y utilidades para implementar backends de datos sin acoplarse a tecnologías específicas como Firebase, Supabase o REST APIs. Actúa como una capa anticorrupción que permite cambiar de backend sin afectar la lógica de negocio.

## ✨ Filosofía

- **Desacoplamiento total**: Sin dependencias a SDKs específicos
- **Capa anticorrupción**: Protege tu lógica de negocio de cambios en el backend
- **Result pattern**: Manejo funcional de errores sin excepciones
- **Type safety**: Aprovecha al máximo el sistema de tipos de Dart
- **Testing friendly**: Fácil de mockear y testear

## 🎯 Características

- ✅ **Result\<T\>** - Manejo funcional de errores
- ✅ **DsFailure** - Sistema tipado de fallos específicos
- ✅ **QuerySpec** - Especificaciones de consulta flexibles
- ✅ **Paginación** - Sistema de cursores opacos
- ✅ **Streams reactivos** - Para actualizaciones en tiempo real
- ✅ **Transacciones** - Soporte para operaciones atómicas
- ✅ **Marcadores de capacidades** - Para identificar funcionalidades del backend
- ✅ **Null-safety** - Completamente null-safe
- ✅ **Documentación** - Documentada completamente en español

## 📦 Instalación

```yaml
dependencies:
  iaut_core_datasource: ^1.0.0
```

## 🚀 Uso Básico

### 1. Definir tu entidad

```dart
class User {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  // Métodos de serialización
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}
```

### 2. Implementar el DataSource

```dart
class FirestoreUserDataSource implements GenericDataSource<User>, GenericQueryDataSource<User> {
  final FirebaseFirestore _firestore;

  FirestoreUserDataSource(this._firestore);

  @override
  Future<Result<User?>> getById(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) return const Result.success(null);

      final user = User.fromJson(doc.data()!);
      return Result.success(user);
    } catch (e) {
      return Result.failure(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> create(String id, User user) async {
    try {
      await _firestore.collection('users').doc(id).set(user.toJson());
      return const Result.success(null);
    } catch (e) {
      return Result.failure(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<User>>> query(QuerySpec spec, {int? limit}) async {
    try {
      var query = _firestore.collection('users').limit(limit ?? 50);

      // Aplicar condiciones WHERE
      for (final condition in spec.where) {
        query = _applyWhereCondition(query, condition);
      }

      // Aplicar ordenamiento
      for (final order in spec.orderBy) {
        query = query.orderBy(order.field, descending: order.direction == OrderDirection.desc);
      }

      final snapshot = await query.get();
      final users = snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();

      return Result.success(users);
    } catch (e) {
      return Result.failure(NetworkFailure(message: e.toString()));
    }
  }

  // Implementar otros métodos...
}
```

### 3. Usar Result Pattern

```dart
final userDataSource = FirestoreUserDataSource(FirebaseFirestore.instance);

// Obtener usuario
final result = await userDataSource.getById('user123');

result.when(
  onSuccess: (user) {
    if (user != null) {
      print('Usuario encontrado: ${user.name}');
    } else {
      print('Usuario no existe');
    }
  },
  onFailure: (failure) {
    switch (failure) {
      case NetworkFailure():
        print('Error de red: ${failure.message}');
      case NotFoundFailure():
        print('Usuario no encontrado');
      case PermissionDeniedFailure():
        print('Sin permisos para acceder');
      default:
        print('Error: ${failure.message}');
    }
  },
);

// O usar métodos funcionales
final userName = result
    .map((user) => user?.name ?? 'Desconocido')
    .getOrElse('Error al cargar');
```

### 4. Consultas Avanzadas

```dart
// Crear especificación de consulta
final spec = QuerySpec()
    .whereEquals('status', 'active')
    .whereGreaterThan('age', 18)
    .orderByDesc('createdAt')
    .withLimit(20);

// Ejecutar consulta
final result = await userDataSource.query(spec);

result.when(
  onSuccess: (users) => print('Encontrados ${users.length} usuarios'),
  onFailure: (failure) => print('Error: ${failure.message}'),
);
```

### 5. Búsquedas Flexibles con Criteria

El método `search` permite consultas flexibles usando un mapa de criterios, ideal para búsquedas dinámicas o cuando los criterios se construyen en runtime:

#### Consulta simple:
```dart
final criteria = {
  'where': [
    {'field': 'status', 'op': '==', 'value': 'active'}
  ]
};

final result = await userDataSource.search(criteria);
result.when(
  onSuccess: (users) => print('Usuarios activos: ${users.length}'),
  onFailure: (failure) => print('Error: ${failure.message}'),
);
```

#### Consulta con múltiples condiciones:
```dart
final criteria = {
  'where': [
    {'field': 'country', 'op': '==', 'value': 'Spain'},
    {'field': 'age', 'op': '>', 'value': 18},
    {'field': 'skills', 'op': 'array-contains', 'value': 'Flutter'}
  ],
  'orderBy': {'field': 'experience', 'direction': 'desc'},
  'limit': 50
};

final result = await userDataSource.search(criteria);
```

#### Búsqueda con paginación:
```dart
final criteria = {
  'where': [
    {'field': 'department', 'op': '==', 'value': 'Engineering'}
  ],
  'orderBy': {'field': 'name', 'direction': 'asc'},
  'limit': 20,
  'cursor': {'startAfter': 'user_123'}
};

final result = await userDataSource.search(criteria);
```

#### Operadores soportados:
- `==` - Igual
- `!=` - No igual
- `>` - Mayor que
- `>=` - Mayor o igual que
- `<` - Menor que
- `<=` - Menor o igual que
- `in` - En la lista de valores
- `array-contains` - El array contiene el valor
- `array-contains-any` - El array contiene cualquiera de los valores

#### Ejemplo de búsqueda dinámica:
```dart
Map<String, dynamic> buildSearchCriteria({
  String? status,
  int? minAge,
  List<String>? skills,
  String? orderField,
  int? limit,
}) {
  final criteria = <String, dynamic>{};
  final whereConditions = <Map<String, dynamic>>[];

  if (status != null) {
    whereConditions.add({'field': 'status', 'op': '==', 'value': status});
  }

  if (minAge != null) {
    whereConditions.add({'field': 'age', 'op': '>=', 'value': minAge});
  }

  if (skills != null && skills.isNotEmpty) {
    whereConditions.add({'field': 'skills', 'op': 'in', 'value': skills});
  }

  if (whereConditions.isNotEmpty) {
    criteria['where'] = whereConditions;
  }

  if (orderField != null) {
    criteria['orderBy'] = {'field': orderField, 'direction': 'asc'};
  }

  if (limit != null) {
    criteria['limit'] = limit;
  }

  return criteria;
}

// Uso
final criteria = buildSearchCriteria(
  status: 'active',
  minAge: 25,
  skills: ['Flutter', 'Dart'],
  orderField: 'name',
  limit: 100,
);

final result = await userDataSource.search(criteria);
```

### 6. Paginación

```dart
// Primera página
final firstPageResult = await userDataSource.queryPage(
  QuerySpec().orderByAsc('name'),
  pageSize: 10,
);

firstPageResult.when(
  onSuccess: (page) {
    print('Página 1: ${page.items.length} elementos');

    if (page.hasNext && page.nextCursor != null) {
      // Cargar siguiente página
      final nextPageResult = await userDataSource.queryPage(
        QuerySpec().orderByAsc('name'),
        pageSize: 10,
        cursor: page.nextCursor,
      );
    }
  },
  onFailure: (failure) => print('Error: ${failure.message}'),
);
```

### 7. Capacidades del Contrato

El paquete define varios contratos especializados para diferentes capacidades de data source:

#### Lectura y Existencia Básica (GenericDataSource)

```dart
// Obtener entidad por ID
final result = await dataSource.getById('user_123');

// Obtener múltiples entidades
final results = await dataSource.getByIds(['user_1', 'user_2', 'user_3']);

// Obtener todas las entidades con límite
final all = await dataSource.getAll(limit: 50);

// Verificar existencia
final exists = await dataSource.exists('user_123');
```

#### Búsquedas y Proyección (SearchCapableDataSource)

**Búsqueda simple:**
```dart
final res = await ds.search({
  "where": [
    {"field": "status", "op": "==", "value": "active"}
  ]
});
```

**Búsqueda compuesta con orden y límite:**
```dart
final res = await ds.search({
  "where": [
    {"field": "country", "op": "==", "value": "ES"},
    {"field": "members", "op": ">", "value": 50},
  ],
  "orderBy": {"field": "createdAt", "direction": "desc"},
  "limit": 20
});
```

**Proyección de campos:**
```dart
final res = await ds.searchProjected({
  "where": [
    {"field": "tier", "op": "==", "value": "premium"}
  ],
  "limit": 10
}, select: ["name", "status"]);
```

#### Streaming Reactivo (StreamingDataSource)

**Streaming de colección por query:**
```dart
final stream = ds.streamCollection({
  "where": [
    {"field": "category", "op": "==", "value": "club"}
  ],
  "orderBy": {"field": "name", "direction": "asc"}
});

stream.listen((result) {
  result.when(
    onSuccess: (items) => print('Items actualizados: ${items.length}'),
    onFailure: (failure) => print('Error: ${failure.message}'),
  );
});
```

**Streaming de documento individual:**
```dart
final stream = ds.streamDoc("club_123");

stream.listen((result) {
  result.when(
    onSuccess: (item) => print('Item actualizado: $item'),
    onFailure: (failure) => print('Error: ${failure.message}'),
  );
});
```

#### Eliminación por Query (DeleteByQueryCapableDataSource)

```dart
final deletedCount = await ds.deleteByQuery({
  "where": [
    {"field": "archived", "op": "==", "value": true}
  ]
});

deletedCount.when(
  onSuccess: (count) => print('$count elementos eliminados'),
  onFailure: (failure) => print('Error: ${failure.message}'),
);
```

#### Interpretación de Criteria

Los mapas de `criteria` son **backend-agnósticos** - cada implementación los traduce según su tecnología específica:

- **Claves sugeridas**:
  - `where` (lista de condiciones)
  - `orderBy` (objeto con field y direction)
  - `limit` (entero)
  - `cursor` (objeto opcional para paginación futura)

- **Operadores orientativos** en `op`:
  - `==`, `!=`, `>`, `>=`, `<`, `<=`
  - `in`, `arrayContains`, `arrayContainsAny`

  *Nota: La implementación decide el soporte real de cada operador.*

#### Ejemplo de Implementación Multi-Capacidad

```dart
class MyDataSource<T> implements
    GenericDataSource<T>,
    SearchCapableDataSource<T>,
    StreamingDataSource<T>,
    DeleteByQueryCapableDataSource<T> {

  // Implementar todos los métodos según el backend específico
  // (Firestore, Supabase, REST API, etc.)
}
```

## 🏗️ Implementando Backends

### Ejemplo: REST API DataSource

```dart
class RestApiUserDataSource implements GenericDataSource<User> {
  final http.Client _client;
  final String _baseUrl;

  RestApiUserDataSource(this._client, this._baseUrl);

  @override
  Future<Result<User?>> getById(String id) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/users/$id'));

      if (response.statusCode == 404) {
        return const Result.success(null);
      }

      if (response.statusCode != 200) {
        return Result.failure(NetworkFailure(
          message: 'HTTP ${response.statusCode}'
        ));
      }

      final json = jsonDecode(response.body);
      final user = User.fromJson(json);
      return Result.success(user);
    } catch (e) {
      return Result.failure(NetworkFailure(message: e.toString()));
    }
  }

  // Implementar otros métodos...
}
```

### Ejemplo: Supabase DataSource

```dart
class SupabaseUserDataSource implements GenericDataSource<User>, GenericQueryDataSource<User> {
  final SupabaseClient _supabase;

  SupabaseUserDataSource(this._supabase);

  @override
  Future<Result<List<User>>> query(QuerySpec spec, {int? limit}) async {
    try {
      var query = _supabase.from('users').select();

      // Aplicar filtros
      for (final condition in spec.where) {
        query = _applySupabaseFilter(query, condition);
      }

      // Aplicar ordenamiento
      for (final order in spec.orderBy) {
        query = query.order(order.field, ascending: order.direction == OrderDirection.asc);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final data = await query;
      final users = (data as List).map((json) => User.fromJson(json)).toList();

      return Result.success(users);
    } catch (e) {
      return Result.failure(_mapSupabaseError(e));
    }
  }

  // Implementar otros métodos...
}
```

## 🧪 Testing

El paquete está diseñado para ser fácil de testear:

```dart
class MockUserDataSource implements GenericDataSource<User> {
  final Map<String, User> _users = {};

  @override
  Future<Result<User?>> getById(String id) async {
    final user = _users[id];
    return Result.success(user);
  }

  @override
  Future<Result<void>> create(String id, User user) async {
    _users[id] = user;
    return const Result.success(null);
  }

  // Implementar otros métodos...
}

// En tus tests
void main() {
  group('UserService', () {
    late MockUserDataSource dataSource;
    late UserService userService;

    setUp(() {
      dataSource = MockUserDataSource();
      userService = UserService(dataSource);
    });

    test('should create user successfully', () async {
      final user = User(id: '1', name: 'Test', email: 'test@example.com');

      final result = await userService.createUser(user);

      expect(result.isSuccess, isTrue);
    });
  });
}
```

## 📋 Tipos de Fallos

El paquete incluye fallos específicos para diferentes situaciones:

- **NetworkFailure**: Problemas de conectividad
- **TimeoutFailure**: Operaciones que tardan demasiado
- **PermissionDeniedFailure**: Permisos insuficientes
- **NotFoundFailure**: Recurso no encontrado
- **ConflictFailure**: Conflictos en operaciones
- **SerializationFailure**: Errores de serialización
- **CancelledFailure**: Operaciones canceladas
- **UnknownFailure**: Errores no categorizados

## 🔄 Versionado

Este paquete sigue [Semantic Versioning](https://semver.org/):

- **Major**: Cambios incompatibles en la API
- **Minor**: Nueva funcionalidad compatible hacia atrás
- **Patch**: Correcciones de bugs compatibles

## 🤝 Contribución

Las contribuciones son bienvenidas! Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 🆘 Soporte

- **Issues**: [GitHub Issues](https://github.com/tu-org/iaut_core_datasource/issues)
- **Documentación**: [Dart API Docs](https://pub.dev/documentation/iaut_core_datasource/latest/)
- **Ejemplos**: Ver carpeta `/example` (próximamente)

---

**Desarrollado con ❤️ para la comunidad Flutter/Dart**
