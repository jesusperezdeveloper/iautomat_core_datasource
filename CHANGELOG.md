# Changelog

## 2.0.0

### 🔄 Cambios Importantes (BREAKING CHANGES)
- **GenericDataSource refactorizado**: Ahora es un contrato de solo lectura y existencia
  - ✅ Mantenido: `getById()`, `getAll()`, `exists()`
  - ✅ Añadido: `getByIds()` - obtener múltiples entidades por IDs
  - ❌ Removido: Todas las operaciones CRUD (`create`, `update`, `delete`, `upsert`)
  - ❌ Removido: Operaciones en lote (`createMany`, `updateMany`, etc.)
  - ❌ Removido: `search()` y `count()`

### 🆕 Nuevos Contratos Especializados
- **SearchCapableDataSource<T>**: Capacidades de búsqueda y proyección
  - `search(Map<String, dynamic> criteria)` - Búsqueda flexible con criteria
  - `searchProjected(criteria, {select})` - Proyección de campos específicos
- **StreamingDataSource<T>**: Streaming reactivo
  - `streamCollection(criteria)` - Stream de colección por query
  - `streamDoc(id)` - Stream de documento individual
- **DeleteByQueryCapableDataSource<T>**: Eliminación por query
  - `deleteByQuery(criteria)` - Eliminar basado en criteria

### 📚 Documentación
- **README actualizado**: Nueva sección "Capacidades del Contrato"
- **Ejemplos completos**: Uso de cada contrato especializado
- **Criteria backend-agnóstico**: Explicación de interpretación flexible

### 🧪 Testing
- **Test de superficie**: Verificación de compilación de todos los contratos
- **Eliminados**: Tests obsoletos de operaciones en lote

### 🎯 Filosofía
- **Separación de responsabilidades**: Cada contrato tiene un propósito específico
- **Composición flexible**: Implementa solo las capacidades que necesites
- **Backend-agnóstico**: Criteria interpretan según la tecnología específica

## 1.1.0

## 1.0.0

### Añadido
- **Core Types**: Implementación de `Result<T>` sealed class para manejo funcional de errores
- **Failures**: Sistema completo de fallos tipados (`DsFailure`) con variantes específicas
- **Pagination**: Sistema de paginación con cursores opacos (`Page<T>`, `PageCursor`)
- **Query System**: Especificaciones de consulta flexibles (`QuerySpec`, `WhereCondition`, `OrderBy`)
- **Type Definitions**: Typedefs para serialización (`FromJson<T>`, `ToJson<T>`, `IdExtractor<T>`)
- **Annotations**: Anotaciones para APIs experimentales e internas

### Contratos
- **GenericDataSource**: Interfaz básica para operaciones CRUD
- **GenericQueryDataSource**: Capacidades avanzadas de consulta y paginación
- **RealtimeQueryDataSource**: Streams reactivos para cambios en tiempo real
- **TransactionalDataSource**: Soporte para operaciones transaccionales
- **BatchDataSource**: Operaciones en lote sin garantías transaccionales
- **Repository Markers**: Marcadores para capacidades específicas (readonly, realtime, cache, etc.)

### Utilidades
- **Guards**: Validadores para parámetros de entrada con API fluida
- **Clock**: Abstracción del sistema de tiempo para facilitar testing
- **Time Utils**: Utilidades para manipulación de fechas y tiempo relativo

### Características
- ✅ Null-safety completo
- ✅ Documentación dartdoc en español
- ✅ Sin dependencias externas de Firebase/Supabase
- ✅ Arquitectura desacoplada y extensible
- ✅ Soporte completo para testing con mocks
- ✅ Linting con very_good_analysis
- ✅ CI/CD con GitHub Actions

### Notas Técnicas
- SDK mínimo: Dart 3.9.2
- Flutter mínimo: 3.22.0
- Licencia: MIT
- Publicación: Privada (publish_to: "none")
