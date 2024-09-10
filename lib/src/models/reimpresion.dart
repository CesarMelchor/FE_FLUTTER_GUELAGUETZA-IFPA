class Reimpresion {
  final String folio;
  final String idArtesano;
  final String rama;
  final String descripcion;
  final String antiguedad;
  final String taller;
  final String registroMarca;
  final String terminal;
  final String certificacion;
  final String pasada;
  final String aripo;
  final String nombre;
  final String paterno;
  final String materno;
  final String fecha;
  final String calle;
  final String numero;
  final String cp;
  final String curp;
  final String distrito;
  final String region;
  final String municipio;
  final String sexo;
  final String etnia;

  Reimpresion({
    required this.folio, required this.idArtesano, required this.rama, required this.descripcion,
    required this.antiguedad, required this.taller, required this.registroMarca, required this.terminal,
    required this.certificacion, required this.pasada, required this.aripo, required this.nombre, 
    required this.paterno, required this.materno, required this.calle, required this.numero, required this.cp,
    required this.curp, required this.distrito, required this.region, required this.municipio, required this.fecha,
    required this.sexo, required this.etnia
  });

  factory Reimpresion.fromJson(Map<String, dynamic> json) {
    return Reimpresion(
      folio: json['folio'],
      idArtesano: json['id_artesano'],
      rama: json['nombre_rama'],
      descripcion: json['descripcion1'],
      antiguedad: json['antiguedad'],
      taller: json['nombre_taller'],
      registroMarca: json['registro_marca'],
      terminal: json['terminal_venta'],
      certificacion: json['certificacion_oaxaca'],
      pasada: json['expoferia_pasada'],
      aripo: json['aripo_credencial'],
      nombre: json['nombre'],
      paterno: json['primer_apellido'],
      materno: json['segundo_apellido'],
      fecha: json['fecha_nacimiento'],
      calle: json['calle'],
      numero: json['num_exterior'],
      cp: json['cp'],
      sexo: json['sexo'],
      curp: json['curp'],
      etnia: json['etnia'],
      distrito: json['distrito'],
      region: json['region'],
      municipio: json['municipio'],
    );
  }
}
