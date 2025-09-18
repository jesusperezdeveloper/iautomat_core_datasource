import 'package:meta/meta.dart';

/// Representa los diferentes tipos de fallos que pueden ocurrir
/// en operaciones de data source.
///
/// [DsFailure] es una clase sealed que define todos los posibles
/// fallos que pueden ocurrir al interactuar con fuentes de datos,
/// proporcionando información específica para cada tipo de error.
@sealed
@immutable
abstract class DsFailure {

  /// Crea una instancia de DsFailure.
  const DsFailure({
    required this.message,
    this.cause,
    this.stackTrace,
  });
  /// Mensaje descriptivo del fallo.
  final String message;

  /// Causa original del fallo, si está disponible.
  final Object? cause;

  /// Stack trace del fallo, si está disponible.
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DsFailure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          cause == other.cause);

  @override
  int get hashCode => Object.hash(runtimeType, message, cause);
}

/// Fallo de red o conectividad.
@sealed
class NetworkFailure extends DsFailure {
  /// Crea una instancia de NetworkFailure.
  const NetworkFailure({
    super.message = 'Error de red',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'NetworkFailure: $message';
}

/// Fallo por timeout en la operación.
@sealed
class TimeoutFailure extends DsFailure {
  /// Crea una instancia de TimeoutFailure.
  const TimeoutFailure({
    super.message = 'Tiempo de espera agotado',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'TimeoutFailure: $message';
}

/// Fallo por permisos insuficientes.
@sealed
class PermissionDeniedFailure extends DsFailure {
  /// Crea una instancia de PermissionDeniedFailure.
  const PermissionDeniedFailure({
    super.message = 'Permisos insuficientes',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'PermissionDeniedFailure: $message';
}

/// Fallo por recurso no encontrado.
@sealed
class NotFoundFailure extends DsFailure {
  /// Crea una instancia de NotFoundFailure.
  const NotFoundFailure({
    super.message = 'Recurso no encontrado',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'NotFoundFailure: $message';
}

/// Fallo por conflicto en la operación.
@sealed
class ConflictFailure extends DsFailure {
  /// Crea una instancia de ConflictFailure.
  const ConflictFailure({
    super.message = 'Conflicto en la operación',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'ConflictFailure: $message';
}

/// Fallo en la serialización/deserialización de datos.
@sealed
class SerializationFailure extends DsFailure {
  /// Crea una instancia de SerializationFailure.
  const SerializationFailure({
    super.message = 'Error de serialización',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'SerializationFailure: $message';
}

/// Fallo por operación cancelada.
@sealed
class CancelledFailure extends DsFailure {
  /// Crea una instancia de CancelledFailure.
  const CancelledFailure({
    super.message = 'Operación cancelada',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'CancelledFailure: $message';
}

/// Fallo genérico o desconocido.
@sealed
class UnknownFailure extends DsFailure {
  /// Crea una instancia de UnknownFailure.
  const UnknownFailure({
    super.message = 'Error desconocido',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() => 'UnknownFailure: $message';
}

