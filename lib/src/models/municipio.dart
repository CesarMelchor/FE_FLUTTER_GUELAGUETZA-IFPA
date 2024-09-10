class Municipio {
  final String idMunicipio;
  final String municipio;
  final String idDistrito;
  final String sistNorm;

  Municipio({
    required this.idMunicipio,
    required this.municipio,
    required this.idDistrito,
    required this.sistNorm
  });

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      idMunicipio: json['id_municipio'],
      municipio: json['municipio'],
      idDistrito: json['id_distrito'],
      sistNorm: json['sist_norm_int']
    );
  }
}
