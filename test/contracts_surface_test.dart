import 'package:iaut_core_datasource/iaut_core_datasource.dart';
import 'package:test/test.dart';

/// Test de superficie para verificar que todas las interfaces se compilen correctamente.
///
/// Este test no ejecuta lógica real, solo verifica que las firmas
/// de los contratos sean correctas y que los exports funcionen.
void main() {
  group('Contracts Surface Test', () {
    test('GenericDataSource should compile with basic read operations', () {
      final dataSource = FakeGenericDataSource<String>();

      // Verificar que todos los métodos existen
      expect(dataSource.getById, isA<Function>());
      expect(dataSource.getByIds, isA<Function>());
      expect(dataSource.getAll, isA<Function>());
      expect(dataSource.exists, isA<Function>());
    });

    test('SearchCapableDataSource should compile with search operations', () {
      final dataSource = FakeSearchCapableDataSource<String>();

      // Verificar que todos los métodos existen
      expect(dataSource.search, isA<Function>());
      expect(dataSource.searchProjected, isA<Function>());
    });

    test('StreamingDataSource should compile with streaming operations', () {
      final dataSource = FakeStreamingDataSource<String>();

      // Verificar que todos los métodos existen
      expect(dataSource.streamCollection, isA<Function>());
      expect(dataSource.streamDoc, isA<Function>());
    });

    test('DeleteByQueryCapableDataSource should compile with delete operations', () {
      final dataSource = FakeDeleteByQueryCapableDataSource<String>();

      // Verificar que todos los métodos existen
      expect(dataSource.deleteByQuery, isA<Function>());
    });

    test('Combined capabilities should work together', () {
      final dataSource = FakeCombinedDataSource<String>();

      // Verificar que implementa todas las capacidades
      expect(dataSource, isA<GenericDataSource<String>>());
      expect(dataSource, isA<SearchCapableDataSource<String>>());
      expect(dataSource, isA<StreamingDataSource<String>>());
      expect(dataSource, isA<DeleteByQueryCapableDataSource<String>>());
    });

    test('Result types should be correctly exposed', () {
      // Verificar que los tipos Result están disponibles
      expect(const Result.success('test'), isA<Result<String>>());
      expect(const Result<String>.failure(NetworkFailure(message: 'test')), isA<Result<String>>());

      // Verificar que los tipos DsFailure están disponibles
      expect(const NetworkFailure(message: 'test'), isA<DsFailure>());
      expect(const NotFoundFailure(message: 'test'), isA<DsFailure>());
    });
  });
}

/// Implementación fake para GenericDataSource
class FakeGenericDataSource<T> implements GenericDataSource<T> {
  @override
  Future<Result<T?>> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Map<String, T?>>> getByIds(List<String> ids) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<T>>> getAll({int? limit}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> exists(String id) {
    throw UnimplementedError();
  }
}

/// Implementación fake para SearchCapableDataSource
class FakeSearchCapableDataSource<T> implements SearchCapableDataSource<T> {
  @override
  Future<Result<List<T>>> search(Map<String, dynamic> criteria) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Map<String, Object?>>>> searchProjected(
    Map<String, dynamic> criteria, {
    List<String> select = const [],
  }) {
    throw UnimplementedError();
  }
}

/// Implementación fake para StreamingDataSource
class FakeStreamingDataSource<T> implements StreamingDataSource<T> {
  @override
  Stream<Result<List<T>>> streamCollection(Map<String, dynamic> criteria) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<T?>> streamDoc(String id) {
    throw UnimplementedError();
  }
}

/// Implementación fake para DeleteByQueryCapableDataSource
class FakeDeleteByQueryCapableDataSource<T> implements DeleteByQueryCapableDataSource<T> {
  @override
  Future<Result<int>> deleteByQuery(Map<String, dynamic> criteria) {
    throw UnimplementedError();
  }
}

/// Implementación fake combinada que implementa todas las capacidades
class FakeCombinedDataSource<T> implements
    GenericDataSource<T>,
    SearchCapableDataSource<T>,
    StreamingDataSource<T>,
    DeleteByQueryCapableDataSource<T> {

  @override
  Future<Result<T?>> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Map<String, T?>>> getByIds(List<String> ids) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<T>>> getAll({int? limit}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> exists(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<T>>> search(Map<String, dynamic> criteria) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Map<String, Object?>>>> searchProjected(
    Map<String, dynamic> criteria, {
    List<String> select = const [],
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<List<T>>> streamCollection(Map<String, dynamic> criteria) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<T?>> streamDoc(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<int>> deleteByQuery(Map<String, dynamic> criteria) {
    throw UnimplementedError();
  }
}
