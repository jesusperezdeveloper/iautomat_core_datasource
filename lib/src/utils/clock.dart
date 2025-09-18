/// Abstracción del reloj del sistema para facilitar testing y control de tiempo.
///
/// Proporciona una interfaz abstracta para obtener la fecha/hora actual,
/// permitiendo inyectar implementaciones mock en tests.
abstract class Clock {
  /// Obtiene la fecha y hora actual.
  DateTime now();

  /// Obtiene la fecha y hora actual en UTC.
  DateTime nowUtc() => now().toUtc();

  /// Obtiene el timestamp actual en milisegundos desde época Unix.
  int nowMillis() => now().millisecondsSinceEpoch;

  /// Obtiene el timestamp actual en segundos desde época Unix.
  int nowSeconds() => now().millisecondsSinceEpoch ~/ 1000;

  /// Instancia por defecto que usa el reloj del sistema.
  static Clock get system => _SystemClock();

  /// Instancia actual del reloj (puede ser sobrescrita para testing).
  static Clock _current = system;

  /// Obtiene la instancia actual del reloj.
  static Clock get current => _current;

  /// Establece la instancia del reloj (útil para testing).
  static void setCurrent(Clock clock) {
    _current = clock;
  }

  /// Restablece el reloj al sistema por defecto.
  static void reset() {
    _current = system;
  }
}

/// Implementación del reloj que usa el tiempo real del sistema.
class _SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  int nowMillis() => DateTime.now().millisecondsSinceEpoch;

  @override
  int nowSeconds() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

/// Implementación de reloj fijo para testing.
class FixedClock implements Clock {
  final DateTime _fixedTime;

  /// Crea un reloj fijo con el tiempo especificado.
  const FixedClock(this._fixedTime);

  /// Crea un reloj fijo con el tiempo actual.
  FixedClock.now() : _fixedTime = DateTime.now();

  /// Crea un reloj fijo con una fecha específica.
  FixedClock.fromDate(int year, [int month = 1, int day = 1])
      : _fixedTime = DateTime(year, month, day);

  @override
  DateTime now() => _fixedTime;

  @override
  DateTime nowUtc() => _fixedTime.toUtc();

  @override
  int nowMillis() => _fixedTime.millisecondsSinceEpoch;

  @override
  int nowSeconds() => _fixedTime.millisecondsSinceEpoch ~/ 1000;
}

/// Implementación de reloj que avanza manualmente para testing.
class ManualClock implements Clock {
  DateTime _currentTime;

  /// Crea un reloj manual con el tiempo inicial especificado.
  ManualClock(this._currentTime);

  /// Crea un reloj manual empezando desde ahora.
  ManualClock.now() : _currentTime = DateTime.now();

  /// Crea un reloj manual desde una fecha específica.
  ManualClock.fromDate(int year, [int month = 1, int day = 1])
      : _currentTime = DateTime(year, month, day);

  @override
  DateTime now() => _currentTime;

  @override
  DateTime nowUtc() => _currentTime.toUtc();

  @override
  int nowMillis() => _currentTime.millisecondsSinceEpoch;

  @override
  int nowSeconds() => _currentTime.millisecondsSinceEpoch ~/ 1000;

  /// Avanza el reloj por la duración especificada.
  void advance(Duration duration) {
    _currentTime = _currentTime.add(duration);
  }

  /// Retrocede el reloj por la duración especificada.
  void rewind(Duration duration) {
    _currentTime = _currentTime.subtract(duration);
  }

  /// Establece el tiempo a un valor específico.
  void setTime(DateTime time) {
    _currentTime = time;
  }

  /// Avanza el reloj al siguiente día.
  void nextDay() {
    advance(const Duration(days: 1));
  }

  /// Avanza el reloj a la siguiente hora.
  void nextHour() {
    advance(const Duration(hours: 1));
  }

  /// Avanza el reloj al siguiente minuto.
  void nextMinute() {
    advance(const Duration(minutes: 1));
  }
}

/// Utilidades relacionadas con tiempo y fechas.
class TimeUtils {
  /// Convierte milisegundos desde época Unix a DateTime.
  static DateTime fromMillis(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Convierte segundos desde época Unix a DateTime.
  static DateTime fromSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  /// Obtiene el inicio del día para una fecha.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Obtiene el final del día para una fecha.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Verifica si una fecha es hoy.
  static bool isToday(DateTime date) {
    final now = Clock.current.now();
    return startOfDay(date) == startOfDay(now);
  }

  /// Verifica si una fecha es ayer.
  static bool isYesterday(DateTime date) {
    final yesterday = Clock.current.now().subtract(const Duration(days: 1));
    return startOfDay(date) == startOfDay(yesterday);
  }

  /// Verifica si una fecha es mañana.
  static bool isTomorrow(DateTime date) {
    final tomorrow = Clock.current.now().add(const Duration(days: 1));
    return startOfDay(date) == startOfDay(tomorrow);
  }

  /// Calcula los días entre dos fechas.
  static int daysBetween(DateTime start, DateTime end) {
    final startDay = startOfDay(start);
    final endDay = startOfDay(end);
    return endDay.difference(startDay).inDays;
  }

  /// Obtiene una fecha relativa en formato legible.
  static String getRelativeTime(DateTime date) {
    final now = Clock.current.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Ayer';
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) return 'Hace 1 hora';
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) return 'Hace 1 minuto';
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Ahora';
    }
  }
}

/// Extensiones útiles para DateTime.
extension DateTimeExtensions on DateTime {
  /// Verifica si esta fecha es hoy.
  bool get isToday => TimeUtils.isToday(this);

  /// Verifica si esta fecha es ayer.
  bool get isYesterday => TimeUtils.isYesterday(this);

  /// Verifica si esta fecha es mañana.
  bool get isTomorrow => TimeUtils.isTomorrow(this);

  /// Obtiene el inicio del día para esta fecha.
  DateTime get startOfDay => TimeUtils.startOfDay(this);

  /// Obtiene el final del día para esta fecha.
  DateTime get endOfDay => TimeUtils.endOfDay(this);

  /// Obtiene el tiempo relativo en formato legible.
  String get relativeTime => TimeUtils.getRelativeTime(this);

  /// Calcula los días desde esta fecha hasta ahora.
  int get daysUntilNow => TimeUtils.daysBetween(this, Clock.current.now());

  /// Calcula los días desde ahora hasta esta fecha.
  int get daysFromNow => TimeUtils.daysBetween(Clock.current.now(), this);
}