import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import 'pagination.dart';

/// Operadores de comparación para consultas.
enum QueryOperator {
  /// Igual (==)
  eq,
  /// No igual (!=)
  ne,
  /// Mayor que (>)
  gt,
  /// Mayor o igual que (>=)
  gte,
  /// Menor que (<)
  lt,
  /// Menor o igual que (<=)
  lte,
  /// En la lista de valores
  isIn,
  /// Contiene el array especificado
  arrayContains,
  /// Contiene cualquiera de los valores del array
  arrayContainsAny,
}

/// Dirección de ordenamiento.
enum OrderDirection {
  /// Ascendente (A-Z, 0-9)
  asc,
  /// Descendente (Z-A, 9-0)
  desc,
}

/// Condición WHERE para consultas.
@immutable
class WhereCondition {
  /// Campo a filtrar.
  final String field;

  /// Operador de comparación.
  final QueryOperator operator;

  /// Valor para la comparación.
  final dynamic value;

  /// Crea una condición WHERE.
  const WhereCondition({
    required this.field,
    required this.operator,
    required this.value,
  });

  /// Crea una condición de igualdad.
  WhereCondition.equals(String field, dynamic value)
      : this(field: field, operator: QueryOperator.eq, value: value);

  /// Crea una condición de no igualdad.
  WhereCondition.notEquals(String field, dynamic value)
      : this(field: field, operator: QueryOperator.ne, value: value);

  /// Crea una condición mayor que.
  WhereCondition.greaterThan(String field, dynamic value)
      : this(field: field, operator: QueryOperator.gt, value: value);

  /// Crea una condición mayor o igual que.
  WhereCondition.greaterThanOrEqual(String field, dynamic value)
      : this(field: field, operator: QueryOperator.gte, value: value);

  /// Crea una condición menor que.
  WhereCondition.lessThan(String field, dynamic value)
      : this(field: field, operator: QueryOperator.lt, value: value);

  /// Crea una condición menor o igual que.
  WhereCondition.lessThanOrEqual(String field, dynamic value)
      : this(field: field, operator: QueryOperator.lte, value: value);

  /// Crea una condición IN.
  WhereCondition.whereIn(String field, List<dynamic> values)
      : this(field: field, operator: QueryOperator.isIn, value: values);

  /// Crea una condición array-contains.
  WhereCondition.arrayContains(String field, dynamic value)
      : this(field: field, operator: QueryOperator.arrayContains, value: value);

  /// Crea una condición array-contains-any.
  WhereCondition.arrayContainsAny(String field, List<dynamic> values)
      : this(field: field, operator: QueryOperator.arrayContainsAny, value: values);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhereCondition &&
          field == other.field &&
          operator == other.operator &&
          const DeepCollectionEquality().equals(value, other.value));

  @override
  int get hashCode => Object.hash(
        field,
        operator,
        const DeepCollectionEquality().hash(value),
      );

  @override
  String toString() => 'WhereCondition($field $operator $value)';
}

/// Especificación de ordenamiento.
@immutable
class OrderBy {
  /// Campo por el cual ordenar.
  final String field;

  /// Dirección del ordenamiento.
  final OrderDirection direction;

  /// Crea una especificación de ordenamiento.
  const OrderBy({
    required this.field,
    this.direction = OrderDirection.asc,
  });

  /// Crea un ordenamiento ascendente.
  OrderBy.asc(String field) : this(field: field, direction: OrderDirection.asc);

  /// Crea un ordenamiento descendente.
  OrderBy.desc(String field) : this(field: field, direction: OrderDirection.desc);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderBy &&
          field == other.field &&
          direction == other.direction);

  @override
  int get hashCode => Object.hash(field, direction);

  @override
  String toString() => 'OrderBy($field ${direction.name})';
}

/// Especificación completa de consulta.
@immutable
class QuerySpec {
  /// Condiciones WHERE de la consulta.
  final List<WhereCondition> where;

  /// Especificaciones de ordenamiento.
  final List<OrderBy> orderBy;

  /// Límite de resultados.
  final int? limit;

  /// Cursor para empezar después de este punto (exclusivo).
  final PageCursor? startAfter;

  /// Cursor para empezar en este punto (inclusivo).
  final PageCursor? startAt;

  /// Cursor para terminar antes de este punto (exclusivo).
  final PageCursor? endBefore;

  /// Cursor para terminar en este punto (inclusivo).
  final PageCursor? endAt;

  /// Campos específicos a seleccionar (opcional).
  final List<String>? select;

  /// Crea una especificación de consulta.
  const QuerySpec({
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.startAfter,
    this.startAt,
    this.endBefore,
    this.endAt,
    this.select,
  }) : assert(limit == null || limit > 0, 'limit debe ser mayor que 0');

  /// Crea una consulta vacía.
  const QuerySpec.empty() : this();

  /// Crea una consulta solo con límite.
  QuerySpec.limit(int limit) : this(limit: limit);

  /// Agrega una condición WHERE a la consulta.
  QuerySpec addWhere(WhereCondition condition) {
    return copyWith(where: [...where, condition]);
  }

  /// Agrega una condición WHERE de igualdad.
  QuerySpec whereEquals(String field, dynamic value) {
    return addWhere(WhereCondition.equals(field, value));
  }

  /// Agrega un ordenamiento a la consulta.
  QuerySpec addOrderBy(OrderBy order) {
    return copyWith(orderBy: [...orderBy, order]);
  }

  /// Agrega un ordenamiento ascendente.
  QuerySpec orderByAsc(String field) {
    return addOrderBy(OrderBy.asc(field));
  }

  /// Agrega un ordenamiento descendente.
  QuerySpec orderByDesc(String field) {
    return addOrderBy(OrderBy.desc(field));
  }

  /// Establece el límite de la consulta.
  QuerySpec withLimit(int limit) {
    return copyWith(limit: limit);
  }

  /// Establece el cursor de inicio.
  QuerySpec withStartAfter(PageCursor cursor) {
    return copyWith(startAfter: cursor);
  }

  /// Establece el cursor de inicio inclusivo.
  QuerySpec withStartAt(PageCursor cursor) {
    return copyWith(startAt: cursor);
  }

  /// Establece los campos a seleccionar.
  QuerySpec withSelect(List<String> fields) {
    return copyWith(select: fields);
  }

  /// Crea una copia de la consulta con los cambios especificados.
  QuerySpec copyWith({
    List<WhereCondition>? where,
    List<OrderBy>? orderBy,
    int? limit,
    PageCursor? startAfter,
    PageCursor? startAt,
    PageCursor? endBefore,
    PageCursor? endAt,
    List<String>? select,
  }) {
    return QuerySpec(
      where: where ?? this.where,
      orderBy: orderBy ?? this.orderBy,
      limit: limit ?? this.limit,
      startAfter: startAfter ?? this.startAfter,
      startAt: startAt ?? this.startAt,
      endBefore: endBefore ?? this.endBefore,
      endAt: endAt ?? this.endAt,
      select: select ?? this.select,
    );
  }

  /// Indica si la consulta tiene condiciones WHERE.
  bool get hasWhere => where.isNotEmpty;

  /// Indica si la consulta tiene ordenamiento.
  bool get hasOrderBy => orderBy.isNotEmpty;

  /// Indica si la consulta tiene cursores de paginación.
  bool get hasCursors =>
      startAfter != null || startAt != null || endBefore != null || endAt != null;

  /// Indica si la consulta tiene selección de campos específicos.
  bool get hasSelect => select != null && select!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuerySpec &&
          const ListEquality().equals(where, other.where) &&
          const ListEquality().equals(orderBy, other.orderBy) &&
          limit == other.limit &&
          startAfter == other.startAfter &&
          startAt == other.startAt &&
          endBefore == other.endBefore &&
          endAt == other.endAt &&
          const ListEquality().equals(select, other.select));

  @override
  int get hashCode => Object.hash(
        const ListEquality().hash(where),
        const ListEquality().hash(orderBy),
        limit,
        startAfter,
        startAt,
        endBefore,
        endAt,
        const ListEquality().hash(select),
      );

  @override
  String toString() {
    final parts = <String>[];
    if (hasWhere) parts.add('where: ${where.length} conditions');
    if (hasOrderBy) parts.add('orderBy: ${orderBy.length} fields');
    if (limit != null) parts.add('limit: $limit');
    if (hasCursors) parts.add('cursors: yes');
    if (hasSelect) parts.add('select: ${select!.length} fields');
    return 'QuerySpec(${parts.join(', ')})';
  }
}