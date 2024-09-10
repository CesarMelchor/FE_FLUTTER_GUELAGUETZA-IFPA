class Etnia {
  final String idGrupo;
  final String nombreEtnia;

  Etnia({
    required this.idGrupo,
    required this.nombreEtnia,
  });

  factory Etnia.fromJson(Map<String, dynamic> json) {
    return Etnia(
      idGrupo: json['id_grupo'],
      nombreEtnia: json['nombre_etnia'],
    );
  }
}
