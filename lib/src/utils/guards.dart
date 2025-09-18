/// Utilidades para validar parámetros de entrada.
///
/// Proporciona funciones helper para validar y normalizar
/// parámetros comunes en operaciones de data source.
library;

/// Valida que un string no sea null ni vacío.
///
/// [value] es el string a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el string si es válido.
/// Lanza [ArgumentError] si es null o vacío.
String requireNonEmpty(String? value, {String name = 'value'}) {
  if (value == null || value.isEmpty) {
    throw ArgumentError.value(value, name, 'No puede ser null o vacío');
  }
  return value;
}

/// Valida que un string no sea null, vacío o solo espacios en blanco.
///
/// [value] es el string a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el string trimmed si es válido.
/// Lanza [ArgumentError] si es null, vacío o solo espacios.
String requireNonBlank(String? value, {String name = 'value'}) {
  if (value == null || value.trim().isEmpty) {
    throw ArgumentError.value(
      value,
      name,
      'No puede ser null, vacío o solo espacios',
    );
  }
  return value.trim();
}

/// Valida que un número sea positivo.
///
/// [value] es el número a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el número si es válido.
/// Lanza [ArgumentError] si es null o no positivo.
int requirePositive(int? value, {String name = 'value'}) {
  if (value == null || value <= 0) {
    throw ArgumentError.value(value, name, 'Debe ser un número positivo');
  }
  return value;
}

/// Valida que un número no sea negativo.
///
/// [value] es el número a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el número si es válido.
/// Lanza [ArgumentError] si es null o negativo.
int requireNonNegative(int? value, {String name = 'value'}) {
  if (value == null || value < 0) {
    throw ArgumentError.value(value, name, 'No puede ser negativo');
  }
  return value;
}

/// Valida que un número esté dentro de un rango específico.
///
/// [value] es el número a validar.
/// [min] es el valor mínimo permitido (inclusivo).
/// [max] es el valor máximo permitido (inclusivo).
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el número si está en el rango.
/// Lanza [ArgumentError] si está fuera del rango.
int requireInRange(int? value, int min, int max, {String name = 'value'}) {
  if (value == null || value < min || value > max) {
    throw ArgumentError.value(
      value,
      name,
      'Debe estar entre $min y $max (inclusivo)',
    );
  }
  return value;
}

/// Valida que una lista no sea null ni vacía.
///
/// [value] es la lista a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna la lista si es válida.
/// Lanza [ArgumentError] si es null o vacía.
List<T> requireNonEmptyList<T>(List<T>? value, {String name = 'list'}) {
  if (value == null || value.isEmpty) {
    throw ArgumentError.value(value, name, 'No puede ser null o vacía');
  }
  return value;
}

/// Valida que un objeto no sea null.
///
/// [value] es el objeto a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el objeto si no es null.
/// Lanza [ArgumentError] si es null.
T requireNonNull<T>(T? value, {String name = 'value'}) {
  if (value == null) {
    throw ArgumentError.value(value, name, 'No puede ser null');
  }
  return value;
}

/// Valida que un string represente un ID válido.
///
/// Un ID válido es no null, no vacío, no solo espacios,
/// y opcionalmente puede cumplir con un patrón específico.
///
/// [id] es el ID a validar.
/// [pattern] es el patrón opcional que debe cumplir el ID.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el ID trimmed si es válido.
/// Lanza [ArgumentError] si no cumple con los criterios.
String requireValidId(String? id, {RegExp? pattern, String name = 'id'}) {
  final validId = requireNonBlank(id, name: name);

  if (pattern != null && !pattern.hasMatch(validId)) {
    throw ArgumentError.value(
      id,
      name,
      'No cumple con el patrón requerido: ${pattern.pattern}',
    );
  }

  return validId;
}

/// Valida que un límite de página sea válido.
///
/// Un límite válido debe ser positivo y no exceder el máximo permitido.
///
/// [limit] es el límite a validar.
/// [maxLimit] es el límite máximo permitido.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el límite si es válido.
/// Lanza [ArgumentError] si no es válido.
int requireValidPageLimit(
  int? limit, {
  int maxLimit = 1000,
  String name = 'limit',
}) {
  if (limit == null) return maxLimit;
  return requireInRange(limit, 1, maxLimit, name: name);
}

/// Normaliza un string eliminando espacios extras y convirtiéndolo a lowercase.
///
/// [value] es el string a normalizar.
///
/// Retorna el string normalizado o null si el input es null.
String? normalizeString(String? value) {
  return value?.trim().toLowerCase();
}

/// Valida que un email tenga un formato básico válido.
///
/// [email] es el email a validar.
/// [name] es el nombre del parámetro para mensajes de error.
///
/// Retorna el email normalizado si es válido.
/// Lanza [ArgumentError] si no tiene un formato válido.
String requireValidEmail(String? email, {String name = 'email'}) {
  final validEmail = requireNonBlank(email, name: name);

  // Patrón básico de email
  final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  if (!emailPattern.hasMatch(validEmail)) {
    throw ArgumentError.value(
      email,
      name,
      'No tiene un formato de email válido',
    );
  }

  return validEmail.toLowerCase();
}

/// Valida múltiples condiciones a la vez.
///
/// [conditions] es una lista de funciones que validan diferentes condiciones.
/// Cada función debe lanzar una excepción si la validación falla.
///
/// Ejecuta todas las validaciones y recopila todos los errores.
/// Lanza [ArgumentError] con todos los mensajes de error si alguna falla.
void requireAll(List<void Function()> conditions) {
  final errors = <String>[];

  for (final condition in conditions) {
    try {
      condition();
    } on Exception catch (e) {
      errors.add(e.toString());
    }
  }

  if (errors.isNotEmpty) {
    throw ArgumentError(
      'Múltiples errores de validación: ${errors.join(', ')}',
    );
  }
}

/// Clase para construcción fluida de validaciones.
class Validator<T> {
  Validator._(this._value, this._name);
  final T _value;
  final String _name;

  /// Crea un validador para el valor dado.
  static Validator<T> of<T>(T value, {String name = 'value'}) {
    return Validator._(value, name);
  }

  /// Valida que el valor no sea null.
  void notNull() {
    requireNonNull(_value, name: _name);
  }

  /// Valida que el string no esté vacío (solo para strings).
  void notEmpty() {
    if (_value is String) {
      requireNonEmpty(_value as String, name: _name);
    }
  }

  /// Valida que el número sea positivo (solo para números).
  void positive() {
    if (_value is int) {
      requirePositive(_value as int, name: _name);
    }
  }

  /// Aplica una validación personalizada.
  void custom(bool Function(T) predicate, String message) {
    if (!predicate(_value)) {
      throw ArgumentError.value(_value, _name, message);
    }
  }

  /// Retorna el valor validado.
  T get value => _value;
}
