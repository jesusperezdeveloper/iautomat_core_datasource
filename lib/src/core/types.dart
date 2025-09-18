/// Función para convertir de JSON a un objeto tipo [T].
///
/// Utilizada por los adaptadores de data source para deserializar
/// datos desde diferentes backends (Firestore, REST API, etc.).
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// Función para convertir un objeto tipo [T] a JSON.
///
/// Utilizada por los adaptadores de data source para serializar
/// datos hacia diferentes backends (Firestore, REST API, etc.).
typedef ToJson<T> = Map<String, dynamic> Function(T value);

/// Función para extraer el ID de un objeto tipo [T].
///
/// Algunos backends requieren extraer el ID del objeto para
/// operaciones de creación/actualización. Retorna null si
/// el objeto no tiene ID o si no se puede extraer.
typedef IdExtractor<T> = String? Function(T value);

/// Adaptador que combina las funciones de serialización para un tipo [T].
///
/// Proporciona una manera conveniente de agrupar las funciones
/// de conversión para un tipo específico.
class JsonAdapter<T> {
  /// Crea un adaptador JSON con las funciones proporcionadas.
  const JsonAdapter({
    required this.fromJson,
    required this.toJson,
    this.idExtractor,
  });

  /// Función para convertir de JSON al tipo [T].
  final FromJson<T> fromJson;

  /// Función para convertir del tipo [T] a JSON.
  final ToJson<T> toJson;

  /// Función opcional para extraer el ID del tipo [T].
  final IdExtractor<T>? idExtractor;

  /// Convierte un objeto JSON al tipo [T].
  T fromMap(Map<String, dynamic> json) => fromJson(json);

  /// Convierte un objeto del tipo [T] a JSON.
  Map<String, dynamic> toMap(T value) => toJson(value);

  /// Extrae el ID del objeto si el extractor está disponible.
  String? extractId(T value) => idExtractor?.call(value);

  /// Convierte una lista de JSON al tipo [List<T>].
  List<T> fromJsonList(List<dynamic> jsonList) {
    return jsonList.cast<Map<String, dynamic>>().map(fromJson).toList();
  }

  /// Convierte una lista del tipo [T] a una lista de JSON.
  List<Map<String, dynamic>> toJsonList(List<T> values) {
    return values.map(toJson).toList();
  }
}
