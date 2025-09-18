import '../core/result.dart';
import '../core/query.dart';
import '../core/pagination.dart';

/// Contrato para capacidades avanzadas de consulta y paginación.
///
/// Esta interfaz extiende las capacidades básicas de un data source
/// para incluir consultas complejas, paginación y streams reactivos.
///
/// [T] es el tipo de entidad que maneja este data source.
abstract class GenericQueryDataSource<T> {
  /// Ejecuta una consulta y retorna los resultados.
  ///
  /// [spec] especifica las condiciones, ordenamiento y límites de la consulta.
  /// [limit] puede sobrescribir el límite especificado en [spec].
  ///
  /// Retorna [Result.success] con la lista de entidades que coinciden
  /// con la consulta (puede estar vacía) o [Result.failure] si ocurre un error.
  Future<Result<List<T>>> query(
    QuerySpec spec, {
    int? limit,
  });

  /// Ejecuta una consulta paginada y retorna una página de resultados.
  ///
  /// [spec] especifica las condiciones y ordenamiento de la consulta.
  /// [pageSize] especifica el número máximo de elementos por página.
  /// [cursor] especifica desde dónde comenzar la paginación.
  ///
  /// Retorna [Result.success] con una [Page] de resultados
  /// o [Result.failure] si ocurre un error.
  Future<Result<Page<T>>> queryPage(
    QuerySpec spec, {
    int pageSize = 20,
    PageCursor? cursor,
  });

  /// Crea un stream reactivo de una colección de entidades.
  ///
  /// [spec] especifica las condiciones y ordenamiento para filtrar
  /// las entidades en tiempo real.
  ///
  /// El stream emite una nueva lista cada vez que hay cambios
  /// en la colección que afecten a la consulta especificada.
  ///
  /// Retorna un [Stream] que emite [Result.success] con listas
  /// actualizadas o [Result.failure] si ocurre un error.
  Stream<Result<List<T>>> streamCollection(QuerySpec spec);

  /// Crea un stream reactivo de una entidad específica.
  ///
  /// [id] es el identificador único de la entidad a observar.
  ///
  /// El stream emite un nuevo valor cada vez que la entidad cambia.
  /// Emite null si la entidad no existe o es eliminada.
  ///
  /// Retorna un [Stream] que emite [Result.success] con la entidad
  /// actualizada (o null) o [Result.failure] si ocurre un error.
  Stream<Result<T?>> streamDoc(String id);

  /// Cuenta las entidades que coinciden con una consulta.
  ///
  /// [spec] especifica las condiciones para filtrar las entidades.
  ///
  /// Retorna [Result.success] con el número de entidades que coinciden
  /// con la consulta o [Result.failure] si ocurre un error.
  Future<Result<int>> countQuery(QuerySpec spec);

  /// Verifica si existen entidades que coincidan con una consulta.
  ///
  /// [spec] especifica las condiciones para filtrar las entidades.
  ///
  /// Es más eficiente que [countQuery] cuando solo necesitas saber
  /// si hay al menos una entidad que coincida.
  ///
  /// Retorna [Result.success] con true si hay al menos una entidad
  /// que coincida, false si no hay ninguna, o [Result.failure]
  /// si ocurre un error.
  Future<Result<bool>> existsQuery(QuerySpec spec);
}

/// Contrato para capacidades de consulta en tiempo real.
///
/// Proporciona métodos adicionales para observar cambios
/// en queries específicas con mayor granularidad.
///
/// [T] es el tipo de entidad que maneja este data source.
abstract class RealtimeQueryDataSource<T> {
  /// Crea un stream de cambios individuales en una consulta.
  ///
  /// [spec] especifica las condiciones de la consulta a observar.
  ///
  /// A diferencia de [streamCollection], este stream emite eventos
  /// de cambio específicos (añadido, modificado, eliminado) en lugar
  /// de toda la lista actualizada.
  ///
  /// Útil para optimizar actualizaciones en UI cuando trabajas
  /// con listas grandes.
  Stream<Result<QueryChange<T>>> streamQueryChanges(QuerySpec spec);
}

/// Representa un cambio individual en una consulta.
class QueryChange<T> {
  /// Tipo de cambio.
  final ChangeType type;

  /// Entidad afectada por el cambio.
  final T entity;

  /// Índice anterior de la entidad (para movimientos).
  final int? oldIndex;

  /// Nuevo índice de la entidad.
  final int newIndex;

  /// Crea un cambio de consulta.
  const QueryChange({
    required this.type,
    required this.entity,
    required this.newIndex,
    this.oldIndex,
  });

  /// Crea un cambio de adición.
  QueryChange.added(T entity, int index)
      : this(
          type: ChangeType.added,
          entity: entity,
          newIndex: index,
        );

  /// Crea un cambio de modificación.
  QueryChange.modified(T entity, int oldIndex, int newIndex)
      : this(
          type: ChangeType.modified,
          entity: entity,
          oldIndex: oldIndex,
          newIndex: newIndex,
        );

  /// Crea un cambio de eliminación.
  QueryChange.removed(T entity, int oldIndex)
      : this(
          type: ChangeType.removed,
          entity: entity,
          newIndex: -1,
          oldIndex: oldIndex,
        );

  @override
  String toString() => 'QueryChange($type, index: $newIndex)';
}

/// Tipos de cambio en una consulta.
enum ChangeType {
  /// Entidad añadida a la consulta.
  added,

  /// Entidad modificada en la consulta.
  modified,

  /// Entidad eliminada de la consulta.
  removed,
}