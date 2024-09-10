import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalFunctions {
  static launchURL(String urlLaunch) async {
    await canLaunchUrl(Uri.parse(urlLaunch))
        ? await launchUrl(Uri.parse(urlLaunch))
        : throw 'Could not launch $urlLaunch';
  }

  static launchURLPost(clave, inicio, fin, mes) async {
    final Uri toLaunch = Uri(
    scheme : "https", 
    host: "casadelaculturaoaxaca.com",
    path: "api/control_escolar/excel",
    queryParameters: {
      "documento" : "lista",
      'clave': clave, 'inicio' : inicio, 'fin' : fin, 'mes' : mes}
    );

    await canLaunchUrl(toLaunch)
        ? await launchUrl(toLaunch)
        : throw 'Could not launch $toLaunch';
  }

  static launchURLCopeval(fecha, mes, periodo) async {
    final Uri toLaunch = Uri(
    scheme : "https", 
    host: "casadelaculturaoaxaca.com",
    path: "api/control_escolar/excel",
    queryParameters: {
      "documento" : "copevalFinal",
      'fecha_alta': fecha, 'mes_beneficio' : mes, 'periodo_beneficio' : periodo}
    );

    await canLaunchUrl(toLaunch)
        ? await launchUrl(toLaunch)
        : throw 'Could not launch $toLaunch';
  }

  
  static launchURLRegistrosAll() async {
    final Uri toLaunch = Uri(
    scheme : "https", 
    host: "casadelaculturaoaxaca.com",
    path: "api/control_escolar/excel",
    queryParameters: {
      "documento" : "general"}
    );

    await canLaunchUrl(toLaunch)
        ? await launchUrl(toLaunch)
        : throw 'Could not launch $toLaunch';
  }

  static switchPage(BuildContext context, String page) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed("/$page");
  }
}
