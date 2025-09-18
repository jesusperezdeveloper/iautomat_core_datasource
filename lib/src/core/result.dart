import 'package:meta/meta.dart';

import 'failures.dart';

/// Representa el resultado de una operación que puede fallar.
///
/// [Result] es una clase sealed que encapsula el resultado de operaciones
/// que pueden tener éxito o fallar, proporcionando una API funcional
/// para manejar ambos casos de manera segura.
@sealed
abstract class Result<T> {
  const Result();

  /// Crea un resultado exitoso con el [value] proporcionado.
  const factory Result.success(T value) = Success<T>;

  /// Crea un resultado fallido con el [failure] proporcionado.
  const factory Result.failure(DsFailure failure) = Failure<T>;

  /// Verdadero si el resultado es exitoso.
  bool get isSuccess => this is Success<T>;

  /// Verdadero si el resultado es un fallo.
  bool get isFailure => this is Failure<T>;

  /// Retorna el valor si es exitoso, null en caso contrario.
  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return null;
  }

  /// Retorna el valor si es exitoso, [defaultValue] en caso contrario.
  T getOrElse(T defaultValue) {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return defaultValue;
  }

  /// Retorna el valor si es exitoso, el resultado de [defaultValue] en caso contrario.
  T getOrElseGet(T Function() defaultValue) {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return defaultValue();
  }

  /// Aplica [transform] al valor si es exitoso, retorna el mismo fallo en caso contrario.
  Result<R> map<R>(R Function(T value) transform) {
    if (this is Success<T>) {
      return Result.success(transform((this as Success<T>).value));
    }
    return Result.failure((this as Failure<T>).failure);
  }

  /// Aplica [transform] al valor si es exitoso, retorna el mismo fallo en caso contrario.
  /// [transform] debe retornar un [Result].
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    if (this is Success<T>) {
      return transform((this as Success<T>).value);
    }
    return Result.failure((this as Failure<T>).failure);
  }

  /// Aplica [onSuccess] si es exitoso, [onFailure] si es un fallo.
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(DsFailure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    }
    return onFailure((this as Failure<T>).failure);
  }

  /// Aplica [action] al valor si es exitoso.
  Result<T> tap(void Function(T value) action) {
    if (this is Success<T>) {
      final value = (this as Success<T>).value;
      action(value);
      return Result.success(value);
    }
    return this;
  }

  /// Aplica [action] al fallo si es un fallo.
  Result<T> tapError(void Function(DsFailure failure) action) {
    if (this is Failure<T>) {
      final failure = (this as Failure<T>).failure;
      action(failure);
      return Result.failure(failure);
    }
    return this;
  }
}

/// Representa un resultado exitoso.
@sealed
class Success<T> extends Result<T> {
  /// El valor del resultado exitoso.
  final T value;

  /// Crea un resultado exitoso con el [value] proporcionado.
  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Success<T> && value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Representa un resultado fallido.
@sealed
class Failure<T> extends Result<T> {
  /// El fallo que causó el resultado fallido.
  final DsFailure failure;

  /// Crea un resultado fallido con el [failure] proporcionado.
  const Failure(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure<T> && failure == other.failure);

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Failure($failure)';
}

