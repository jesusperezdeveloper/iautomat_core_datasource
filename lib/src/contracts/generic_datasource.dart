import '../core/result.dart';

/// Contrato básico para operaciones de lectura y existencia en un data source genérico.
///
/// Esta interfaz define las operaciones fundamentales de consulta que debe
/// implementar cualquier adaptador de data source para tipos específicos.
///
/// [T] es el tipo de entidad que maneja este data source.
abstract class GenericDataSource<T> {
  /// Obtiene una entidad por su ID.
  ///
  /// Retorna [Result.success] con la entidad si se encuentra,
  /// [Result.success] con null si no existe, o [Result.failure]
  /// si ocurre un error.
  Future<Result<T?>> getById(String id);

  /// Obtiene múltiples entidades por sus IDs.
  ///
  /// [ids] es la lista de identificadores únicos a buscar.
  ///
  /// Retorna [Result.success] con un mapa donde la clave es el ID
  /// y el valor es la entidad (null si no existe), o [Result.failure]
  /// si ocurre un error durante la operación.
  Future<Result<Map<String, T?>>> getByIds(List<String> ids);

  /// Obtiene todas las entidades, opcionalmente limitadas.
  ///
  /// [limit] especifica el número máximo de entidades a retornar.
  /// Si es null, retorna todas las entidades disponibles.
  ///
  /// Retorna [Result.success] con la lista de entidades (puede estar vacía)
  /// o [Result.failure] si ocurre un error.
  Future<Result<List<T>>> getAll({int? limit});

  /// Verifica si una entidad existe por su ID.
  ///
  /// [id] es el identificador único de la entidad a verificar.
  ///
  /// Retorna [Result.success] con true si existe, false si no existe,
  /// o [Result.failure] si ocurre un error al verificar.
  Future<Result<bool>> exists(String id);
}
