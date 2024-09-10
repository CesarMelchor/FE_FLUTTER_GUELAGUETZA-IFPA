class Organizacion {
  final String idGrupo;
  final String representante;
  final String nombreOrganizacion;
  final String calle;
  final String numeroExterior;
  final String cp;
  final String region;
  final String distrito;
  final String municipio;
  final String localidad;

  Organizacion(
      {required this.idGrupo,
      required this.representante,
      required this.nombreOrganizacion,
      required this.calle,
      required this.numeroExterior,
      required this.cp,
      required this.region,
      required this.distrito,
      required this.municipio,
      required this.localidad

      });

  factory Organizacion.fromJson(Map<String, dynamic> json) {
    return Organizacion(
      idGrupo: json['id_organizacion'],
      representante: json['representante'],
      nombreOrganizacion: json['nombre_organizacion'],
      calle: json['calle'],
      numeroExterior: json['num_exterior'],
      cp: json['cp'],
      region: json['region'],
      distrito: json['distrito'],
      municipio: json['municipio'],
      localidad: json['localidad'],
    );
  }
}
