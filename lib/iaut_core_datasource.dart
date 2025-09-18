/// Librería de contratos puros para data sources desacoplados.
///
/// Esta librería proporciona tipos, interfaces y utilidades para
/// implementar backends de datos sin acoplarse a tecnologías específicas.
library iaut_core_datasource;

// Core types
export 'src/core/result.dart';
export 'src/core/failures.dart';
export 'src/core/pagination.dart';
export 'src/core/query.dart';
export 'src/core/types.dart';
export 'src/core/annotations.dart';

// Contracts
export 'src/contracts/generic_datasource.dart';
export 'src/contracts/query_capabilities.dart';
export 'src/contracts/generic_query_capabilities.dart';
export 'src/contracts/transactions.dart';
export 'src/contracts/repository_markers.dart';

// Utils
export 'src/utils/guards.dart';
export 'src/utils/clock.dart';
