class Rama {
  final String idRama;
  final String nombreRama;
  final String descripcion;
  final String activo;

  Rama({
    required this.idRama,
    required this.nombreRama,
    required this.descripcion,
    required this.activo
  });

  factory Rama.fromJson(Map<String, dynamic> json) {
    return Rama(
      idRama: json['id_rama'],
      nombreRama: json['nombre_rama'],
      descripcion: json['descripcion'],
      activo: json['activo']
    );
  }
}
