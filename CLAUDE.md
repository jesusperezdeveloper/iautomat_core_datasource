# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Comandos de Desarrollo

### Ejecutar tests
```bash
dart test
```

### Análisis de código
```bash
dart analyze
```

### Análisis con warnings fatales
```bash
dart analyze --fatal-warnings
```

### Formatear código
```bash
dart format .
```

### Instalar dependencias
```bash
dart pub get
```

### Verificar actualizaciones
```bash
dart pub outdated
```

## Arquitectura del Proyecto

Este es un paquete Dart puro (no depende de Flutter) que proporciona contratos para data sources desacoplados:

- **lib/**: Código fuente principal del paquete
  - `iaut_core_datasource.dart`: Barrel export principal
  - `src/core/`: Tipos fundamentales (Result<T>, DsFailure, QuerySpec, etc.)
  - `src/contracts/`: Interfaces para data sources
  - `src/utils/`: Utilidades (guards, clock)
- **test/**: Tests unitarios organizados por módulo
- **pubspec.yaml**: Configuración con dependencias mínimas

### Tipos Fundamentales

- **Result<T>**: Sealed class para manejo funcional de errores
- **DsFailure**: Sistema tipado de fallos específicos (Network, Timeout, etc.)
- **QuerySpec**: Especificaciones de consulta con WHERE, ORDER BY, cursores
- **Page<T>**: Sistema de paginación con cursores opacos
- **JsonAdapter<T>**: Adaptador para serialización

### Contratos Principales

- **GenericDataSource<T>**: CRUD básico
- **GenericQueryDataSource<T>**: Consultas avanzadas y paginación
- **TransactionalDataSource**: Operaciones transaccionales
- **Repository Markers**: Marcadores de capacidades (readonly, realtime, etc.)

### Filosofía del Diseño

- **Sin dependencias externas**: Solo `meta` y `collection`
- **Null-safety completo**
- **Result pattern**: Sin excepciones, solo tipos
- **Capa anticorrupción**: Protege lógica de negocio de cambios en backend
- **Testing friendly**: Fácil de mockear

### Convenciones de Código

- Usa `very_good_analysis` para linting estricto
- Documentación completa en español con dartdoc
- Tests organizados por módulo en `test/`
- Nombres descriptivos y consistentes
- SDK mínimo: Dart 3.9.2

### Comandos Útiles para Desarrollo

- Ejecutar test específico: `dart test test/core/result_test.dart`
- Ver coverage: `dart test --coverage`
- Publicar (dry-run): `dart pub publish --dry-run`
- Verificar dependencias: `dart pub deps`

### Estructura de Tests

Los tests están organizados siguiendo la estructura de `lib/src/`:
- `test/core/`: Tests de tipos fundamentales
- Tests de integración en el archivo principal del test

### CI/CD

El proyecto incluye GitHub Actions que ejecutan:
- Análisis estático (`dart analyze`)
- Tests (`dart test`)
- Verificación de formato (`dart format`)
- Verificación de publicación (`dart pub publish --dry-run`)