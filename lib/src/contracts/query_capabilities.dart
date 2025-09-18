import 'package:iaut_core_datasource/src/core/result.dart';

/// Consultas basadas en un criteria flexible.
/// El contrato no dicta interpretación; cada implementación lo traducirá a su backend.
abstract class SearchCapableDataSource<T> {
  /// Busca elementos que cumplan el criteria.
  /// Ejemplos de criteria en README.
  Future<Result<List<T>>> search(Map<String, dynamic> criteria);

  /// Proyección: devuelve mapas con sólo los campos seleccionados.
  /// Útil para evitar overfetch.
  Future<Result<List<Map<String, Object?>>>> searchProjected(
    Map<String, dynamic> criteria, {
    List<String> select = const [],
  });
}

/// Streaming reactivo según criteria.
abstract class StreamingDataSource<T> {
  /// Stream de una colección/consulta. Emite la lista completa cada vez
  /// que hay cambios relevantes. La implementación decide la granularidad.
  Stream<Result<List<T>>> streamCollection(Map<String, dynamic> criteria);

  /// Stream de un documento individual por id.
  Stream<Result<T?>> streamDoc(String id);
}

/// Eliminación basada en query.
/// Devuelve el número de elementos eliminados si el backend puede calcularlo;
/// en caso contrario, puede devolver 0 o un estimado, documentado por la implementación.
abstract class DeleteByQueryCapableDataSource<T> {
  /// Elimina elementos que cumplan el criteria.
  ///
  /// Retorna el número de elementos eliminados o 0 si no se puede calcular.
  Future<Result<int>> deleteByQuery(Map<String, dynamic> criteria);

  /// Indica si este data source soporta eliminación por query.
  bool get supportsDeleteByQuery => true;
}

