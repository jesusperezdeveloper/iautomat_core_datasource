import 'package:meta/meta.dart';

/// Cursor opaco para navegación de páginas.
///
/// Representa una posición específica en un conjunto de resultados
/// paginados. Los cursores son opacos al cliente y su contenido
/// interno es específico del backend utilizado.
@immutable
class PageCursor {
  /// Valor opaco del cursor.
  final String value;

  /// Crea un cursor con el [value] proporcionado.
  const PageCursor(this.value);

  /// Crea un cursor desde un mapa de datos.
  factory PageCursor.fromMap(Map<String, dynamic> map) {
    return PageCursor(map['value'] as String);
  }

  /// Convierte el cursor a un mapa de datos.
  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PageCursor && value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PageCursor($value)';
}

/// Representa una página de resultados con información de paginación.
///
/// Contiene los elementos de la página actual y opcionalmente
/// un cursor para navegar a la siguiente página.
@immutable
class Page<T> {
  /// Elementos de la página actual.
  final List<T> items;

  /// Cursor para la siguiente página, null si no hay más páginas.
  final PageCursor? nextCursor;

  /// Cursor para la página anterior, null si es la primera página.
  final PageCursor? previousCursor;

  /// Indica si hay más páginas después de esta.
  final bool hasNext;

  /// Indica si hay páginas anteriores a esta.
  final bool hasPrevious;

  /// Tamaño total de elementos si está disponible.
  final int? totalSize;

  /// Crea una página con los parámetros proporcionados.
  const Page({
    required this.items,
    this.nextCursor,
    this.previousCursor,
    this.hasNext = false,
    this.hasPrevious = false,
    this.totalSize,
  });

  /// Crea una página vacía.
  const Page.empty()
      : items = const [],
        nextCursor = null,
        previousCursor = null,
        hasNext = false,
        hasPrevious = false,
        totalSize = 0;

  /// Crea una página única con todos los elementos.
  Page.single(List<T> items)
      : items = items,
        nextCursor = null,
        previousCursor = null,
        hasNext = false,
        hasPrevious = false,
        totalSize = items.length;

  /// Número de elementos en esta página.
  int get size => items.length;

  /// Indica si la página está vacía.
  bool get isEmpty => items.isEmpty;

  /// Indica si la página no está vacía.
  bool get isNotEmpty => items.isNotEmpty;

  /// Transforma los elementos de la página usando [transform].
  Page<R> map<R>(R Function(T item) transform) {
    return Page<R>(
      items: items.map(transform).toList(),
      nextCursor: nextCursor,
      previousCursor: previousCursor,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      totalSize: totalSize,
    );
  }

  /// Filtra los elementos de la página usando [predicate].
  Page<T> where(bool Function(T item) predicate) {
    final filteredItems = items.where(predicate).toList();
    return Page<T>(
      items: filteredItems,
      nextCursor: nextCursor,
      previousCursor: previousCursor,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      totalSize: totalSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page<T> &&
          items == other.items &&
          nextCursor == other.nextCursor &&
          previousCursor == other.previousCursor &&
          hasNext == other.hasNext &&
          hasPrevious == other.hasPrevious &&
          totalSize == other.totalSize);

  @override
  int get hashCode => Object.hash(
        items,
        nextCursor,
        previousCursor,
        hasNext,
        hasPrevious,
        totalSize,
      );

  @override
  String toString() =>
      'Page(items: ${items.length}, hasNext: $hasNext, hasPrevious: $hasPrevious)';
}

/// Utilidades para trabajar con paginación.
class PaginationUtils {
  /// Tamaño de página por defecto.
  static const int defaultPageSize = 20;

  /// Tamaño máximo de página.
  static const int maxPageSize = 100;

  /// Valida que el tamaño de página esté dentro de los límites.
  static int validatePageSize(int? pageSize) {
    if (pageSize == null) return defaultPageSize;
    if (pageSize <= 0) return defaultPageSize;
    if (pageSize > maxPageSize) return maxPageSize;
    return pageSize;
  }

  /// Crea un cursor simple basado en string.
  static PageCursor createCursor(String value) {
    return PageCursor(value);
  }

  /// Combina múltiples páginas en una sola.
  static Page<T> combine<T>(List<Page<T>> pages) {
    if (pages.isEmpty) return const Page.empty();
    if (pages.length == 1) return pages.first;

    final allItems = pages.expand((page) => page.items).toList();
    final hasNext = pages.any((page) => page.hasNext);
    final hasPrevious = pages.any((page) => page.hasPrevious);
    final totalSize = pages
        .map((page) => page.totalSize)
        .where((size) => size != null)
        .fold<int?>(null, (acc, size) => (acc ?? 0) + size!);

    return Page<T>(
      items: allItems,
      nextCursor: pages.last.nextCursor,
      previousCursor: pages.first.previousCursor,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      totalSize: totalSize,
    );
  }
}