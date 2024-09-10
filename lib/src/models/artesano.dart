class Artesano {
  final String idArtesano;
  final String nombre;
  final String primerApellido;
  final String segundoApellido;
  final String sexo;
  final String fechaNacimiento;
  final String edoCivil;
  final String curp;
  final String claveIne;
  final String rfc;
  final String calle;
  final String numExterior;
  final String numInterior;
  final String cp;
  final String idRegion;
  final String idMunicipio;
  final String idDistrito;
  final String localidad;
  final String seccion;
  final String telFijo;
  final String telCelular;
  final String correo;
  final String redesSociales;
  final String escolaridad;
  final String idGrupo;
  final String grupoPertenencia;
  final String idOrganizacion;
  final String idMateria;
  final String idVenta;
  final String idComprador;
  final String folioCuis;
  final String foto;
  final String activo;
  final String nombreArchivo;
  final String comentarios;
  final String createdAt;
  final String updatedAt;

  Artesano({
    required this.idArtesano,
    required this.nombre,
    required this.primerApellido,
    required this.segundoApellido,
    required this.sexo,
    required this.fechaNacimiento,
    required this.edoCivil,
    required this.curp,
    required this.claveIne,
    required this.rfc,
    required this.calle,
    required this.numExterior,
    required this.numInterior,
    required this.cp,
    required this.idRegion,
    required this.idMunicipio,
    required this.idDistrito,
    required this.localidad,
    required this.seccion,
    required this.telFijo,
    required this.telCelular,
    required this.correo,
    required this.redesSociales,
    required this.escolaridad,
    required this.idGrupo,
    required this.grupoPertenencia,
    required this.idOrganizacion,
    required this.idMateria,
    required this.idVenta,
    required this.idComprador,
    required this.folioCuis,
    required this.foto,
    required this.activo,
    required this.nombreArchivo,
    required this.comentarios,
    required this.createdAt,
    required this.updatedAt
  });

  factory Artesano.fromJson(Map<String, dynamic> json) {
    return Artesano(
      idArtesano: json['id_artesano'],
      nombre: json['nombre'],
      primerApellido: json['primer_apellido'],
      segundoApellido: json['segundo_apellido'],
      sexo: json['sexo'],
      fechaNacimiento: json['fecha_nacimiento'],
      edoCivil: json['edo_civil'],
      curp: json['curp'],
      claveIne: json['clave_ine'],
      rfc: json['rfc'],
      calle: json['calle'],
      numExterior: json['num_exterior'],
      numInterior: json['num_interior'],
      cp: json['cp'],
      idRegion: json['id_region'],
      idDistrito: json['id_distrito'],
      idMunicipio: json['id_municipio'],
      localidad: json['id_localidad'],
      seccion: json['seccion'],
      telFijo: json['tel_fijo'],
      telCelular: json['tel_celular'],
      correo: json['correo'],
      redesSociales: json['redes_sociales'],
      escolaridad: json['escolaridad'],
      idGrupo: json['id_grupo'],
      grupoPertenencia: json['gpo_pertenencia'],
      idOrganizacion: json['id_organizacion'],
      idMateria: json['id_materia_prima'],
      idVenta: json['id_venta_producto'],
      idComprador: json['id_tipo_comprador'],
      folioCuis: json['folio_cuis'],
      foto: json['foto'],
      activo: json['activo'],
      nombreArchivo: json['nombre_archivo'],
      comentarios: json['comentarios'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}


