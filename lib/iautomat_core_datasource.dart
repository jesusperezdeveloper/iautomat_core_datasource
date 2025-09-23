// Paquete iautomat_core_datasource
//
// Proporciona la infraestructura base para la capa de datos
// en aplicaciones Flutter empresariales.
//
// Este paquete define interfaces estándar, entidades base y utilidades
// para implementar datasources consistentes que siguen los principios
// de Clean Architecture.
//
// ## Características principales:
//
// - **Interfaces estándar**: Contratos consistentes para operaciones CRUD
// - **Múltiples backends**: Soporte para Firebase, REST APIs y más
// - **Cache integrado**: Sistema de cache automático con TTL
// - **Manejo de errores**: Excepciones estandarizadas y reintentos automáticos
// - **Tiempo real**: Soporte para streams y actualizaciones en vivo
// - **Operaciones batch**: Operaciones masivas eficientes
// - **Factory pattern**: Creación simplificada de datasources
//
// ## Uso básico:
//
// ```dart
// // Crear un datasource de Firebase
// final userDataSource = UsersDataSourceFactory.createFirebase();
//
// // Crear un datasource REST
// final userDataSource = UsersDataSourceFactory.createRest(
//   baseUrl: 'https://api.example.com',
// );
//
// // Usar el datasource
// final user = await userDataSource.getById('user123');
// final newUser = await userDataSource.create(UserEntity(...));
// ```

// Core - Clases base y interfaces principales
export 'src/core/base_entity.dart';
export 'src/core/base_datasource.dart';
export 'src/core/base_model.dart';

// Datasources - Módulos de datasources disponibles
export 'src/datasources/users/users_entity.dart';
export 'src/datasources/users/users_contract.dart';
export 'src/datasources/users/users_factory.dart' show UsersDataSourceFactory, DataSourceType;

// Utils - Utilidades públicas
export 'src/utils/exceptions/datasource_exception.dart';
export 'src/utils/typedefs/datasource_typedefs.dart';

// NO exportar implementaciones específicas (Firebase, REST)
// NO exportar mixins internos
// NO exportar barrels internos

/// Versión del paquete
const String packageVersion = '0.1.0';