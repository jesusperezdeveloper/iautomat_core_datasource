/// Marcadores e interfaces para categorizar diferentes tipos de data sources.
///
/// Estos marcadores proporcionan una manera de identificar las capacidades
/// y características específicas de los data sources sin acoplar la
/// implementación a tecnologías específicas.

/// Marcador para data sources de solo lectura.
///
/// Los data sources que implementan este marcador no deben
/// proporcionar operaciones de modificación (create, update, delete).
abstract class ReadOnlyDataSource {
  /// Indica que este data source es de solo lectura.
  bool get isReadOnly => true;
}

/// Marcador para data sources que soportan operaciones en tiempo real.
///
/// Los data sources que implementan este marcador pueden proporcionar
/// streams reactivos para observar cambios en los datos.
abstract class RealtimeDataSource {
  /// Indica que este data source soporta actualizaciones en tiempo real.
  bool get supportsRealtime => true;
}

/// Marcador para data sources que soportan búsqueda de texto completo.
///
/// Los data sources que implementan este marcador pueden realizar
/// búsquedas avanzadas de texto en los contenidos.
abstract class FullTextSearchDataSource {
  /// Indica que este data source soporta búsqueda de texto completo.
  bool get supportsFullTextSearch => true;
}

/// Marcador para data sources que soportan operaciones offline.
///
/// Los data sources que implementan este marcador pueden funcionar
/// sin conexión a internet y sincronizar cuando la conexión se restaura.
abstract class OfflineCapableDataSource {
  /// Indica que este data source puede funcionar offline.
  bool get supportsOffline => true;

  /// Indica si actualmente está en modo offline.
  bool get isOffline;

  /// Sincroniza los cambios locales con el servidor remoto.
  Future<void> sync();
}

/// Marcador para data sources que soportan cache local.
///
/// Los data sources que implementan este marcador mantienen
/// una cache local para mejorar el rendimiento.
abstract class CacheableDataSource {
  /// Indica que este data source soporta cache.
  bool get supportsCache => true;

  /// Limpia toda la cache local.
  Future<void> clearCache();

  /// Invalida la cache para una entidad específica.
  Future<void> invalidateCache(String id);
}

/// Marcador para data sources que soportan versionado de entidades.
///
/// Los data sources que implementan este marcador pueden manejar
/// múltiples versiones de las mismas entidades y detectar conflictos.
abstract class VersionedDataSource {
  /// Indica que este data source soporta versionado.
  bool get supportsVersioning => true;

  /// Obtiene la versión actual de una entidad.
  Future<String?> getVersion(String id);
}

/// Marcador para data sources que soportan auditoría.
///
/// Los data sources que implementan este marcador pueden rastrear
/// quién modificó qué y cuándo.
abstract class AuditableDataSource {
  /// Indica que este data source soporta auditoría.
  bool get supportsAudit => true;
}

/// Marcador para data sources que soportan borrado suave.
///
/// Los data sources que implementan este marcador no eliminan
/// físicamente los registros, sino que los marcan como eliminados.
abstract class SoftDeleteDataSource {
  /// Indica que este data source soporta borrado suave.
  bool get supportsSoftDelete => true;

  /// Restaura una entidad previamente eliminada.
  Future<void> restore(String id);

  /// Elimina permanentemente una entidad.
  Future<void> hardDelete(String id);
}

/// Marcador para data sources que soportan encriptación.
///
/// Los data sources que implementan este marcador encriptan
/// automáticamente los datos sensibles.
abstract class EncryptedDataSource {
  /// Indica que este data source soporta encriptación.
  bool get supportsEncryption => true;
}

/// Marcador para data sources que soportan compresión.
///
/// Los data sources que implementan este marcador comprimen
/// automáticamente los datos para reducir el almacenamiento.
abstract class CompressedDataSource {
  /// Indica que este data source soporta compresión.
  bool get supportsCompression => true;
}

/// Información sobre las capacidades de un data source.
///
/// Proporciona una manera unificada de consultar las capacidades
/// sin necesidad de hacer múltiples verificaciones instanceof.
class DataSourceCapabilities {
  /// Indica si soporta operaciones de solo lectura.
  final bool isReadOnly;

  /// Indica si soporta actualizaciones en tiempo real.
  final bool supportsRealtime;

  /// Indica si soporta búsqueda de texto completo.
  final bool supportsFullTextSearch;

  /// Indica si soporta operaciones offline.
  final bool supportsOffline;

  /// Indica si soporta cache local.
  final bool supportsCache;

  /// Indica si soporta versionado de entidades.
  final bool supportsVersioning;

  /// Indica si soporta auditoría.
  final bool supportsAudit;

  /// Indica si soporta borrado suave.
  final bool supportsSoftDelete;

  /// Indica si soporta encriptación.
  final bool supportsEncryption;

  /// Indica si soporta compresión.
  final bool supportsCompression;

  /// Crea información de capacidades.
  const DataSourceCapabilities({
    this.isReadOnly = false,
    this.supportsRealtime = false,
    this.supportsFullTextSearch = false,
    this.supportsOffline = false,
    this.supportsCache = false,
    this.supportsVersioning = false,
    this.supportsAudit = false,
    this.supportsSoftDelete = false,
    this.supportsEncryption = false,
    this.supportsCompression = false,
  });

  /// Crea capacidades para un data source de solo lectura.
  const DataSourceCapabilities.readOnly()
      : this(isReadOnly: true);

  /// Crea capacidades para un data source en tiempo real.
  const DataSourceCapabilities.realtime()
      : this(supportsRealtime: true);

  /// Crea capacidades completas (todas las funcionalidades).
  const DataSourceCapabilities.full()
      : this(
          supportsRealtime: true,
          supportsFullTextSearch: true,
          supportsOffline: true,
          supportsCache: true,
          supportsVersioning: true,
          supportsAudit: true,
          supportsSoftDelete: true,
          supportsEncryption: true,
          supportsCompression: true,
        );

  @override
  String toString() {
    final features = <String>[];
    if (isReadOnly) features.add('readonly');
    if (supportsRealtime) features.add('realtime');
    if (supportsFullTextSearch) features.add('fulltext');
    if (supportsOffline) features.add('offline');
    if (supportsCache) features.add('cache');
    if (supportsVersioning) features.add('versioning');
    if (supportsAudit) features.add('audit');
    if (supportsSoftDelete) features.add('softdelete');
    if (supportsEncryption) features.add('encryption');
    if (supportsCompression) features.add('compression');

    return 'DataSourceCapabilities(${features.join(', ')})';
  }
}

/// Contrato para data sources que exponen sus capacidades.
abstract class CapabilityAware {
  /// Obtiene las capacidades de este data source.
  DataSourceCapabilities get capabilities;
}