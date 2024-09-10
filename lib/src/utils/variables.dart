import 'package:flutter/material.dart';

class Variables {
  static bool exito = false;
  static bool usuario = false;
  static String fontPlayBlack = "PlayBlack";
  static String fontPlayBlackItalic = "PlayBlackItalic";
  static String fontPlayBold = "PlayBold";
  static String fontPlayBoldItalic = "fontPlayBoldItalic";
  static String fontPlayItalic = "fontPlayItalic";
  static String fontPlayRegular = "fontPlayRegular";
  static String tipoSelected = "";
  static bool avisoPrivacidad = false;

  static ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Variables.colorCafe,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static ButtonStyle raisedButtonStyle2 = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Variables.colorMorado,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static ButtonStyle botonGuelaguetza = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Variables.colorAzul,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      side: BorderSide(width: 5.0, color: Colors.blue),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
  );

  static List siNO = ['SI', 'NO'];
  static List tipoRegistro = ['INDIVIDUAL', 'GRUPO'];

  static var nameFileCredencial = '';
  static var pathFileCredencial = '.';
  static var estado = '';

  static var nameFileCarta = 'NA';
  static var pathFileCarta = 'NA';
  static var nameFilePieza1 = 'NA';
  static var pathFilePieza1 = 'NA';
  static var nameFilePieza2 = 'NA';
  static var pathFilePieza2 = 'NA';
  static var nameFilePieza3 = 'NA';
  static var pathFilePieza3 = 'NA';
  static var nameFileTaller1 = 'NA';
  static var pathFileTaller1 = 'NA';
  static var nameFileTaller2 = 'NA';
  static var pathFileTaller2 = 'NA';
  static var nameFileTaller3 = 'NA';
  static var pathFileTaller3 = 'NA';

  static var nameFileCartaGrupo = 'NA';
  static var pathFileCartaGrupo = 'NA';
  static var nameFilePiezaGrupo1 = 'NA';
  static var pathFilePiezaGrupo1 = 'NA';
  static var nameFilePiezaGrupo2 = 'NA';
  static var pathFilePiezaGrupo2 = 'NA';
  static var nameFilePiezaGrupo3 = 'NA';
  static var pathFilePiezaGrupo3 = 'NA';
  static var nameFileTallerGrupo1 = 'NA';
  static var pathFileTallerGrupo1 = 'NA';
  static var nameFileTallerGrupo2 = 'NA';
  static var pathFileTallerGrupo2 = 'NA';
  static var nameFileTallerGrupo3 = 'NA';
  static var pathFileTallerGrupo3 = 'NA';

  static String typeRegister = "";
  static String curpReim = "";
  static Color colorRosa = const Color.fromRGBO(184, 60, 105, 1);
  static Color colorCafe = const Color.fromRGBO(249, 137, 39, 1);
  static Color colorGris = const Color.fromARGB(237, 158, 158, 158);
  static Color colorMorado = const Color.fromARGB(255, 130, 64, 139);
  static Color colorAzul = const Color.fromARGB(255, 0, 178, 206);
  static double borderRadiusInput = 10;
  static String rfc = "";
  static String folio = "";
  static String idArtesano = ""; 
  static String idArtesanoOrg = "";
  static String nombre = "";
  static String nombreOrganizacion = "";
  static String representanteOrganizacion = "";
  static String paterno = "";
  static String materno = "";
  static String fechaNacimiento = "";
  static String sexo = "";
  static String grupoEtnico = "";
  static String municipio = "";
  static String region = "";
  static String localidad = "";
  static String calle = "";
  static String numero = "";
  static String colonia = "";
  static String cp = "";
  static String curp = "";
  static String movil = "";
  static String fijo = "";
  static String rama1 = "";
  static String des1 = "";
  static String rama2 = "";
  static String des2 = "";
  static String rama3 = "";
  static String des3 = "";
  static String folioGrupo = "";

  static String gruporama1 = "";
  static String grupodes1 = "";
  static String gruporama2 = "";
  static String grupodes2 = "";
  static String gruporama3 = "";
  static String grupodes3 = "";

  static String antiguedad = "";
  static String marca = "";
  static String registroMarca = "SELECCIONAR";
  static String terminalVenta = "SELECCIONAR";
  static String certificacionOaxaca = "SELECCIONAR";
  static String participacionPasada = "SELECCIONAR";
  static String aripo = "SELECCIONAR";
  static bool archivo1 = false;
  static bool archivo2 = false;
  static bool foto1 = false;
  static bool foto2 = false;
  static bool foto3 = false;
  static bool foto4 = false;
  static bool foto5 = false;
  static bool foto6 = false;
}
