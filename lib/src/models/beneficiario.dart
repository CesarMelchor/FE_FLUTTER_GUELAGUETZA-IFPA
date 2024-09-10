class Beneficiario {
  final int id;
  final String curp;
  final String nombre;
  final String paterno;
  final String materno;
  final String rama;
  final String region;
  final String municipio;

  Beneficiario({
    required this.id,
    required this.curp,
    required this.nombre,
    required this.paterno,
    required this.materno,
    required this.rama,
    required this.region,
    required this.municipio
  });

  factory Beneficiario.fromJson(Map<String, dynamic> json) {
    return Beneficiario(
      id: json['id'],
      curp: json['curp'],
      nombre: json['nombre'],
      paterno: json['paterno'],
      materno: json['materno'],
      rama: json['rama'],
      region: json['region'],
      municipio: json['municipio'],
    );
  }

}
