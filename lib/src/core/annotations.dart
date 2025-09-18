/// Marca una API como experimental.
///
/// Las APIs marcadas con esta anotación pueden cambiar en el futuro
/// sin previo aviso y no se garantiza la compatibilidad hacia atrás.
/// Se recomienda usar con precaución en código de producción.
class Experimental {
  /// Crea una anotación experimental con una razón opcional.
  const Experimental([this.reason]);

  /// Razón opcional por la cual la API es experimental.
  final String? reason;
}

/// Marca una API como interna al paquete.
///
/// Las APIs marcadas con esta anotación están destinadas solo
/// para uso interno del paquete y no deben ser utilizadas
/// por código externo.
class Internal {
  /// Crea una anotación para APIs internas.
  const Internal();
}
