import 'package:iaut_core_datasource/src/core/annotations.dart';
import 'package:iaut_core_datasource/src/core/result.dart';

/// Contrato para operaciones transaccionales.
///
/// Proporciona la capacidad de ejecutar múltiples operaciones
/// como una unidad atómica, donde todas las operaciones tienen
/// éxito o todas fallan.
///
/// Las implementaciones específicas del backend deben mapear
/// este contrato a sus mecanismos de transacción correspondientes.
abstract class TransactionalDataSource {
  /// Ejecuta una función dentro de una transacción.
  ///
  /// [action] es la función que contiene las operaciones a ejecutar
  /// de manera transaccional.
  ///
  /// Si cualquier operación dentro de [action] falla o lanza una excepción,
  /// toda la transacción se revierte.
  ///
  /// Retorna [Result.success] con el valor retornado por [action]
  /// si todas las operaciones son exitosas, o [Result.failure]
  /// si ocurre algún error.
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// final result = await dataSource.runTransaction(() async {
  ///   await userDataSource.create('user1', user);
  ///   await profileDataSource.create('profile1', profile);
  ///   return 'success';
  /// });
  /// ```
  Future<Result<R>> runTransaction<R>(
    Future<R> Function(TransactionContext context) action,
  );

  /// Indica si este data source soporta transacciones.
  bool get supportsTransactions => true;
}

/// Contexto de transacción que proporciona acceso a operaciones
/// transaccionales específicas.
///
/// Este contexto se pasa a la función de transacción y puede
/// contener información específica del backend sobre la transacción
/// en curso.
abstract class TransactionContext {
  /// Marca un punto de guardado en la transacción.
  ///
  /// Los puntos de guardado permiten revertir parcialmente
  /// una transacción hasta un punto específico sin cancelar
  /// toda la transacción.
  ///
  /// [name] es el nombre único del punto de guardado.
  ///
  /// Nota: No todos los backends soportan puntos de guardado.
  @Experimental('Los puntos de guardado pueden no estar soportados en todos los backends')
  Future<Result<void>> savepoint(String name);

  /// Revierte la transacción hasta un punto de guardado específico.
  ///
  /// [name] es el nombre del punto de guardado al cual revertir.
  ///
  /// Nota: No todos los backends soportan puntos de guardado.
  @Experimental('Los puntos de guardado pueden no estar soportados en todos los backends')
  Future<Result<void>> rollbackTo(String name);

  /// Obtiene información sobre la transacción actual.
  TransactionInfo get info;
}

/// Información sobre una transacción en curso.
class TransactionInfo {

  /// Crea información de transacción.
  const TransactionInfo({
    required this.id,
    required this.startTime,
    this.isReadOnly = false,
    this.metadata = const {},
  });
  /// ID único de la transacción.
  final String id;

  /// Timestamp de cuando comenzó la transacción.
  final DateTime startTime;

  /// Indica si la transacción es de solo lectura.
  final bool isReadOnly;

  /// Metadatos adicionales específicos del backend.
  final Map<String, dynamic> metadata;

  /// Duración transcurrida desde el inicio de la transacción.
  Duration get elapsed => DateTime.now().difference(startTime);

  @override
  String toString() => 'TransactionInfo(id: $id, elapsed: ${elapsed.inMilliseconds}ms)';
}

/// Contrato para operaciones batch (lote) sin garantías transaccionales.
///
/// A diferencia de las transacciones, las operaciones batch pueden
/// fallar parcialmente, ejecutándose las operaciones exitosas y
/// reportando las que fallaron.
///
/// **Nota**: Las implementaciones de GenericDataSource que incluyen
/// métodos como `createMany`, `upsertMany`, `updateMany` y `deleteMany`
/// pueden mapear internamente a este sistema de batches para optimizar
/// el rendimiento, especialmente en backends que soportan operaciones
/// bulk nativas.
abstract class BatchDataSource {
  /// Ejecuta múltiples operaciones como un lote.
  ///
  /// [operations] es la lista de operaciones a ejecutar.
  ///
  /// Retorna [Result.success] con [BatchResult] que contiene
  /// información sobre las operaciones exitosas y fallidas,
  /// o [Result.failure] si toda la operación batch falla.
  Future<Result<BatchResult>> runBatch(
    List<BatchOperation> operations,
  );
}

/// Operación individual dentro de un batch.
abstract class BatchOperation {

  /// Crea una operación batch.
  const BatchOperation({
    required this.operationId,
    required this.type,
  });
  /// ID único de la operación dentro del batch.
  final String operationId;

  /// Tipo de operación.
  final BatchOperationType type;
}

/// Tipos de operación batch.
enum BatchOperationType {
  /// Operación de creación.
  create,
  /// Operación de actualización.
  update,
  /// Operación de eliminación.
  delete,
  /// Operación de upsert.
  upsert,
}

/// Resultado de una operación batch.
class BatchResult {

  /// Crea un resultado batch.
  const BatchResult({
    required this.successful,
    required this.failed,
    required this.total,
  });
  /// Operaciones que se ejecutaron exitosamente.
  final List<String> successful;

  /// Operaciones que fallaron con sus errores correspondientes.
  final Map<String, String> failed;

  /// Número total de operaciones procesadas.
  final int total;

  /// Número de operaciones exitosas.
  int get successCount => successful.length;

  /// Número de operaciones fallidas.
  int get failureCount => failed.length;

  /// Indica si todas las operaciones fueron exitosas.
  bool get allSuccessful => failureCount == 0;

  /// Indica si todas las operaciones fallaron.
  bool get allFailed => successCount == 0;

  /// Porcentaje de éxito (0.0 a 1.0).
  double get successRate => total > 0 ? successCount / total : 0.0;

  @override
  String toString() =>
      'BatchResult(successful: $successCount, failed: $failureCount, total: $total)';
}

