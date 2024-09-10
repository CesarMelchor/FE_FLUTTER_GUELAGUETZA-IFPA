import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guelaguetza/src/models/reimpresion.dart';
import 'package:guelaguetza/src/utils/global_functions.dart';
import 'package:guelaguetza/src/utils/letter.dart';
import 'package:guelaguetza/src/utils/variables.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:guelaguetza/src/utils/mobile.dart'
    if (dart.library.html) 'package:guelaguetza/src/utils/web.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Response response;

  var dio = Dio();
  Reimpresion reimpresion = Reimpresion(
      folio: "",
      idArtesano: "",
      rama: "",
      descripcion: "",
      antiguedad: "",
      taller: "",
      registroMarca: "",
      terminal: "",
      certificacion: "",
      pasada: "",
      aripo: "",
      nombre: "",
      paterno: "",
      materno: "",
      calle: "",
      numero: "",
      cp: "",
      curp: "",
      distrito: "",
      region: "",
      municipio: "",
      fecha: "",
      sexo: "",
      etnia: "");

  Future getData(curp) async {
    _buildAlertDialogLoading(context);
    response = await dio.get("https://sistema-ioa.com/api/fast_query",
        queryParameters: {"consulta": "reimpresion", "curp": curp});
    final result = response.data;
    reimpresion = Reimpresion.fromJson(result);
    if (response.statusCode == 200) {
      _createFicha(
          reimpresion.idArtesano,
          reimpresion.nombre,
          reimpresion.paterno,
          reimpresion.materno,
          reimpresion.fecha,
          reimpresion.sexo,
          reimpresion.etnia,
          reimpresion.region,
          reimpresion.distrito,
          reimpresion.municipio,
          reimpresion.region,
          reimpresion.calle,
          reimpresion.numero,
          reimpresion.cp,
          reimpresion.folio,
          reimpresion.curp,
          reimpresion.numero,
          reimpresion.taller,
          reimpresion.rama,
          reimpresion.descripcion,
          reimpresion.antiguedad,
          reimpresion.registroMarca,
          reimpresion.terminal,
          reimpresion.certificacion,
          reimpresion.pasada,
          reimpresion.aripo);
      _createPDF(reimpresion.folio, reimpresion.nombre, reimpresion.paterno,
          reimpresion.materno, reimpresion.curp);
    } else {
      // ignore: use_build_context_synchronously
      AchievementView(
        context,
        title: "Aviso",
        subTitle: "Error al obtener datos.",
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.white,
        ),
        color: Colors.red,
        textStyleTitle: const TextStyle(color: Colors.white),
        textStyleSubTitle: const TextStyle(color: Colors.white),
        alignment: Alignment.centerRight,
        duration: const Duration(seconds: 3),
        isCircle: true,
      ).show();
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  TextEditingController curp = TextEditingController();

  bool responsive = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (size.width <= 844) {
      setState(() {
        responsive = true;
      });
    } else {
      setState(() {
        responsive = false;
      });
    }
    return Scaffold(
        body: responsive == false
            ? ListView(
              children: [
                Row(
                    children: [
                      SizedBox(
                          height: Adaptive.h(100),
                          child: Image.asset(
                            "assets/images/imagen_home.png",
                          )),
                      Column(
                        children: [
                          SizedBox(
                            height: Adaptive.h(7),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Adaptive.w(23),
                              ),
                              Text(
                                "REGISTRO PARA",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayItalic,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(0.5),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Adaptive.w(23),
                              ),
                              Text(
                                "SORTEO",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayBlack,
                                    fontSize: 56),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(0.5),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Adaptive.w(23),
                              ),
                              Text(
                                "DE STANDS",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayRegular,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(17),
                          ),
                          Row(
                            children: [
                              SizedBox(width: Adaptive.w(5)),
                              Text(
                                "TIPO DE REGISTRO",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayRegular),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(4),
                          ),
                          Row(
                            children: [
                              SizedBox(width: Adaptive.w(15)),
                              Text(
                                "Elige",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayRegular),
                              ),
                              SizedBox(
                                width: Adaptive.w(1.5),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Variables.colorMorado)),
                                width: Adaptive.w(15),
                                child: FindDropdown(
                                  showSearchBox: false,
                                  items: const ["INDIVIDUAL", "GRUPO"],
                                  // ignore: avoid_print
                                  onChanged: (item) {
                                    setState(() {
                                      Variables.typeRegister = item.toString();
                                    });
                                  },
                                  selectedItem: "SELECCIONAR",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(17),
                          ),
                          Row(
                            children: [
                              SizedBox(width: Adaptive.w(20)),
                              Checkbox(
                                  checkColor: Colors.white,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.disabled)) {
                                      return Variables.colorMorado.withOpacity(.32);
                                    }
                                    return Variables.colorMorado;
                                  }),
                                  value: Variables.avisoPrivacidad,
                                  onChanged: (value) {
                                    setState(() {
                                      Variables.avisoPrivacidad =
                                          !Variables.avisoPrivacidad;
                                    });
                                  }),
                              SizedBox(
                                width: Adaptive.w(1.5),
                              ),
                              InkWell(
                                onTap: () {
                                  GlobalFunctions.launchURL(
                                      "https://www.oaxaca.gob.mx/ifpa/wp-content/uploads/sites/46/2023/06/AVISO_PRIVACIDAD_SIMPLIFICADO.pdf");
                                },
                                child: Text(
                                  "ACEPTO AVISO DE PRIVACIDAD",
                                  style: TextStyle(
                                      fontFamily: Variables.fontPlayRegular),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(4),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Adaptive.w(23),
                              ),
                              OutlinedButton(
                                  style: Variables.raisedButtonStyle2,
                                  onPressed: () {
                                    if (Variables.typeRegister == "") {
                                      AchievementView(
                                        context,
                                        title: "Advertencia",
                                        subTitle:
                                            "Selecciona un tipo de registro antes de continuar.",
                                        icon: const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.white,
                                        ),
                                        color: Colors.amber,
                                        textStyleTitle:
                                            const TextStyle(color: Colors.white),
                                        textStyleSubTitle:
                                            const TextStyle(color: Colors.white),
                                        alignment: Alignment.centerRight,
                                        duration: const Duration(seconds: 3),
                                        isCircle: true,
                                      ).show();
                                    } else if (Variables.avisoPrivacidad == true) {
                                      if (Variables.typeRegister == "INDIVIDUAL") {
                                        context.vRouter.to('/individual');
                                      } else if (Variables.typeRegister ==
                                          "GRUPO") {
                                        context.vRouter.to('/grupo');
                                      }
                                    } else {
                                      AchievementView(
                                        context,
                                        title: "Mensaje",
                                        subTitle:
                                            "No es posible continuar sin aceptar el aviso de privacidad.",
                                        icon: const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.white,
                                        ),
                                        color: Colors.amber,
                                        textStyleTitle:
                                            const TextStyle(color: Colors.white),
                                        textStyleSubTitle:
                                            const TextStyle(color: Colors.white),
                                        alignment: Alignment.centerRight,
                                        duration: const Duration(seconds: 3),
                                        isCircle: true,
                                      ).show();
                                    }
                                  },
                                  child: Text(
                                    "Continuar",
                                    style: TextStyle(
                                        fontFamily: Variables.fontPlayRegular,
                                        color: Colors.white),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(5),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Adaptive.w(25),
                              ),
                              InkWell(
                                onTap: () {
                                  if (responsive == false) {
                                    _buildAlertDialogReimpresion(context);
                                  } else {
                                    _buildAlertDialogReimpresionResponsive(context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "REIMPRIME TU FOLIO",
                                      style: TextStyle(
                                          fontFamily: Variables.fontPlayRegular,
                                          color: Variables.colorMorado,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      "assets/images/IMPRIMIR-07.png",
                                      height: Adaptive.h(5),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
              ],
            )
            :
            // elementos de celular

            ListView(
                children: [
                  SizedBox(
                    height: Adaptive.h(5),
                  ),
                  Center(
                    child: Text(
                      "REGISTRO PARA",
                      style: TextStyle(
                          fontFamily: Variables.fontPlayItalic, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(0.5),
                  ),
                  Center(
                    child: Text(
                      "SORTEO",
                      style: TextStyle(
                          fontFamily: Variables.fontPlayBlack, fontSize: 56),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(0.5),
                  ),
                  Center(
                    child: Text(
                      "DE STANDS",
                      style: TextStyle(
                          fontFamily: Variables.fontPlayRegular, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(17),
                  ),
                  Center(
                    child: Text(
                      "TIPO DE REGISTRO",
                      style: TextStyle(fontFamily: Variables.fontPlayRegular),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                    child: Row(
                      children: [
                        Text(
                          "Elige",
                          style:
                              TextStyle(fontFamily: Variables.fontPlayRegular),
                        ),
                        SizedBox(
                          width: Adaptive.w(1.5),
                        ),
                        SizedBox(
                          width: Adaptive.w(70),
                          child: CustomSearchableDropDown(
                              items: Variables.tipoRegistro,
                              label: 'SELECCIONAR',
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  border:
                                      Border.all(color: Variables.colorMorado)),
                              dropDownMenuItems:
                                  Variables.tipoRegistro.map((item) {
                                return item;
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  Variables.typeRegister = value.toString();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(17),
                  ),
                  Row(
                    children: [
                      SizedBox(width: Adaptive.w(20)),
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Variables.colorMorado.withOpacity(.32);
                            }
                            return Variables.colorMorado;
                          }),
                          value: Variables.avisoPrivacidad,
                          onChanged: (value) {
                            setState(() {
                              Variables.avisoPrivacidad =
                                  !Variables.avisoPrivacidad;
                            });
                          }),
                      SizedBox(
                        width: Adaptive.w(1.5),
                      ),
                      InkWell(
                        onTap: () {
                          GlobalFunctions.launchURL(
                              "https://www.oaxaca.gob.mx/ifpa/wp-content/uploads/sites/46/2023/06/AVISO_PRIVACIDAD_SIMPLIFICADO.pdf");
                        },
                        child: Text(
                          "ACEPTO AVISO DE PRIVACIDAD",
                          style:
                              TextStyle(fontFamily: Variables.fontPlayRegular),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: Adaptive.w(40),
                      ),
                      OutlinedButton(
                          style: Variables.raisedButtonStyle2,
                          onPressed: () {
                            if (Variables.typeRegister == "") {
                              AchievementView(
                                context,
                                title: "Advertencia",
                                subTitle:
                                    "Selecciona un tipo de registro antes de continuar.",
                                icon: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.white,
                                ),
                                color: Colors.amber,
                                textStyleTitle:
                                    const TextStyle(color: Colors.white),
                                textStyleSubTitle:
                                    const TextStyle(color: Colors.white),
                                alignment: Alignment.centerRight,
                                duration: const Duration(seconds: 3),
                                isCircle: true,
                              ).show();
                            } else if (Variables.avisoPrivacidad == true) {
                              if (Variables.typeRegister == "INDIVIDUAL") {
                                context.vRouter.to('/individual');
                              } else if (Variables.typeRegister == "GRUPO") {
                                context.vRouter.to('/grupo');
                              }
                            } else {
                              AchievementView(
                                context,
                                title: "Mensaje",
                                subTitle:
                                    "No es posible continuar sin aceptar el aviso de privacidad.",
                                icon: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.white,
                                ),
                                color: Colors.amber,
                                textStyleTitle:
                                    const TextStyle(color: Colors.white),
                                textStyleSubTitle:
                                    const TextStyle(color: Colors.white),
                                alignment: Alignment.centerRight,
                                duration: const Duration(seconds: 3),
                                isCircle: true,
                              ).show();
                            }
                          },
                          child: Text(
                            "Continuar",
                            style: TextStyle(
                                fontFamily: Variables.fontPlayRegular,
                                color: Colors.white),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: Adaptive.h(5),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Adaptive.w(30)),
                    child: InkWell(
                      onTap: () {
                        if (responsive == false) {
                          _buildAlertDialogReimpresion(context);
                        } else {
                          _buildAlertDialogReimpresionResponsive(context);
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "REIMPRIME TU FOLIO",
                            style: TextStyle(
                                fontFamily: Variables.fontPlayRegular,
                                color: Variables.colorMorado,
                                fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            "assets/images/IMPRIMIR-07.png",
                            height: Adaptive.h(5),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  _buildAlertDialogReimpresion(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(5)),
            content: Row(
              children: [
                Image.asset(
                  "assets/images/DESCARGA-05.png",
                  color: Colors.purple,
                  height: Adaptive.h(50),
                ),
                SizedBox(
                  width: Adaptive.w(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿DESEAS REIMPRIMIR TU FOLIO?",
                      style: TextStyle(fontFamily: Variables.fontPlayRegular),
                    ),
                    SizedBox(
                      height: Adaptive.h(5),
                    ),
                    SizedBox(
                      width: Adaptive.w(25),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalLetters(),
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9a-zA-ZñÑ ]"))
                        ],
                        controller: curp,
                        onChanged: (value) {
                          setState(() {
                            Variables.curpReim = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Variables.colorAzul),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Variables.borderRadiusInput))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Variables.colorGris),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Variables.borderRadiusInput))),
                            floatingLabelStyle:
                                TextStyle(color: Variables.colorAzul),
                            label: const Text("CURP")),
                      ),
                    ),
                    SizedBox(
                      height: Adaptive.h(5),
                    ),
                Row(
                  children: [
                    OutlinedButton(
                        style: Variables.raisedButtonStyle2,
                        onPressed: () {
                          getData(Variables.curpReim);
                        },
                        child: Text(
                          "IMPRIMIR",
                          style:
                              TextStyle(fontFamily: Variables.fontPlayRegular),
                        )),
                    SizedBox(
                      width: Adaptive.w(5),
                    ),
                    OutlinedButton(
                        style: Variables.raisedButtonStyle2,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "FINALIZAR",
                          style:
                              TextStyle(fontFamily: Variables.fontPlayRegular),
                        )),
                  ],
                ),
                  ],
                ),
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
        barrierColor: Colors.white70,
        barrierDismissible: false);
  }

  _buildAlertDialogReimpresionResponsive(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(5)),
            content: Column(
              children: [
                Text(
                  "¿DESEAS REIMPRIMIR TU FOLIO?",
                  style: TextStyle(fontFamily: Variables.fontPlayRegular),
                ),
                SizedBox(
                  height: Adaptive.h(5),
                ),
                SizedBox(
                  width: Adaptive.w(45),
                  child: TextFormField(
                    inputFormatters: [
                      CapitalLetters(),
                      FilteringTextInputFormatter.allow(
                          RegExp("[0-9a-zA-ZñÑ ]"))
                    ],
                    controller: curp,
                    onChanged: (value) {
                      setState(() {
                        Variables.curpReim = value;
                      });
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Variables.colorAzul),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Variables.borderRadiusInput))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Variables.colorGris),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Variables.borderRadiusInput))),
                        floatingLabelStyle:
                            TextStyle(color: Variables.colorAzul),
                        label: const Text("CURP")),
                  ),
                ),
                SizedBox(
                  height: Adaptive.h(5),
                ),
                Row(
                  children: [
                    OutlinedButton(
                        style: Variables.raisedButtonStyle2,
                        onPressed: () {
                          getData(Variables.curpReim);
                        },
                        child: Text(
                          "IMPRIMIR",
                          style:
                              TextStyle(fontFamily: Variables.fontPlayRegular),
                        )),
                    SizedBox(
                      width: Adaptive.w(5),
                    ),
                    OutlinedButton(
                        style: Variables.raisedButtonStyle2,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "FINALIZAR",
                          style:
                              TextStyle(fontFamily: Variables.fontPlayRegular),
                        )),
                  ],
                ),
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
        barrierColor: Colors.white70,
        barrierDismissible: false);
  }

  _buildAlertDialogLoading(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("CARGANDO"),
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(5)),
            content: Image.asset(
              "assets/images/cargando.gif",
              width: Adaptive.w(50),
              height: Adaptive.h(50),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
        barrierColor: Colors.white70,
        barrierDismissible: false);
  }
}

Future<void> _createPDF(folio, nombre, paterno, materno, curp) async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  page.graphics.drawImage(
      PdfBitmap(await _readImageData("assets/images/registro_ok.jpg")),
      const Rect.fromLTWH(4, 20, 500, 280));

  page.graphics.drawString(
      folio,
      brush: PdfBrushes.purple,
      PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(250, 148, 0, 0));

  page.graphics.drawString(
      nombre + paterno + materno,
      brush: PdfBrushes.purple,
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(282, 189, 0, 0));

  page.graphics.drawString(
      "CURP :", PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(252, 199, 0, 0));

  page.graphics.drawString(
      curp,
      brush: PdfBrushes.purple,
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(290, 199, 0, 0));

  List<int> bytes = await document.save();
  document.dispose();
  saveAndLaunchFile(bytes, "Folio_$folio.pdf");
}

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load(name);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<void> _createFicha(
    artesanoiD,
    nombre,
    paterno,
    materno,
    fecha,
    sexo,
    etnia,
    region,
    estado,
    municipio,
    localidad,
    calle,
    numero,
    cp,
    folio,
    curp,
    celular,
    marca,
    rama,
    descripcion,
    tiempo,
    registro,
    terminal,
    certificacion,
    ediciones,
    aripo) async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  page.graphics.drawImage(
      PdfBitmap(await _readImageData("images/logo_guelaguetza.jpg")),
      const Rect.fromLTWH(350, 0, 150, 70));

  page.graphics.drawString(
      "FICHA DE REGISTRO", PdfStandardFont(PdfFontFamily.helvetica, 14),
      bounds: const Rect.fromLTWH(50, 0, 0, 0));

  page.graphics.drawString(
      "SORTEO DE STANDS", PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: const Rect.fromLTWH(50, 20, 0, 0));

  final PdfGrid grid = PdfGrid();
  final PdfGrid grid2 = PdfGrid();
  final PdfGrid grid3 = PdfGrid();
  final PdfGrid grid4 = PdfGrid();
  final PdfGrid grid5 = PdfGrid();
  final PdfGrid grid6 = PdfGrid();
  final PdfGrid grid7 = PdfGrid();
  final PdfGrid grid8 = PdfGrid();
  final PdfGrid grid9 = PdfGrid();

  grid.columns.add(count: 1);
  PdfGridRow row = grid.rows.add();
  grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.dimGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 11));
  row.cells[0].style.stringFormat =
      PdfStringFormat(alignment: PdfTextAlignment.center, wordSpacing: 5);

  row.cells[0].value = 'DATOS GENERALES';
  grid.style.cellPadding = PdfPaddings(left: 5, top: 5);

  grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 65, page.getClientSize().width, page.getClientSize().height));

  grid2.columns.add(count: 3);
  PdfGridRow row2 = grid2.rows.add();

  grid2.style.cellPadding = PdfPaddings(top: 5);
  row2.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row2.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row2.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row2.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row2.cells[0].value = 'NOMBRE(S)';
  row2.cells[1].value = 'APELLIDO PATERNO';
  row2.cells[2].value = 'APELLIDO MATERNO';

  PdfGridRow row3 = grid2.rows.add();

  row3.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row3.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row3.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row3.cells[0].value = nombre;
  row3.cells[1].value = paterno;
  row3.cells[2].value = materno;

  grid3.columns.add(count: 4);
  PdfGridRow row4 = grid3.rows.add();

  grid3.style.cellPadding = PdfPaddings(top: 5);
  row4.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row4.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row4.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row4.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row4.cells[3].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row4.cells[0].value = 'FECHA DE NACIMIENTO';
  row4.cells[1].value = 'SEXO';
  row4.cells[2].value = 'GRUPO ETNICO';
  row4.cells[3].value = 'REGION';

  PdfGridRow row5 = grid3.rows.add();

  row5.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row5.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row5.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row5.cells[3].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row5.cells[0].value = fecha;
  row5.cells[1].value = sexo;
  row5.cells[2].value = etnia;
  row5.cells[3].value = region;

  grid2.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 95, page.getClientSize().width, page.getClientSize().height));

  grid3.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 135, page.getClientSize().width, page.getClientSize().height));

  grid4.columns.add(count: 3);
  PdfGridRow row6 = grid4.rows.add();

  grid4.style.cellPadding = PdfPaddings(top: 5);
  row6.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row6.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row6.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row6.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row6.cells[0].value = 'DISTRITO';
  row6.cells[1].value = 'MUNICIPIO';
  row6.cells[2].value = 'LOCALIDAD';

  PdfGridRow row7 = grid4.rows.add();

  grid4.style.cellPadding = PdfPaddings(top: 5);
  row7.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row7.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row7.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row7.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row7.cells[0].value = estado;
  row7.cells[1].value = municipio;
  row7.cells[2].value = localidad;

  grid4.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 175, page.getClientSize().width, page.getClientSize().height));

  grid5.columns.add(count: 1);
  PdfGridRow row8 = grid5.rows.add();
  grid5.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 11));
  row8.cells[0].style.stringFormat =
      PdfStringFormat(alignment: PdfTextAlignment.center, wordSpacing: 5);

  row8.cells[0].value = 'DOMICILIO';
  grid5.style.cellPadding = PdfPaddings(left: 5, top: 5);

  PdfGridRow row9 = grid5.rows.add();

  grid5.style.cellPadding = PdfPaddings(top: 5);
  row9.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row9.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row9.cells[0].value = "$calle, $numero, $cp";

  grid5.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 217, page.getClientSize().width, page.getClientSize().height));

  grid6.columns.add(count: 3);
  PdfGridRow row10 = grid6.rows.add();

  grid6.style.cellPadding = PdfPaddings(top: 5);
  row10.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row10.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row10.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row10.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row10.cells[0].value = 'FOLIO DE ARTESANO';
  row10.cells[1].value = 'CURP';
  row10.cells[2].value = 'CELULUAR';

  PdfGridRow row11 = grid6.rows.add();

  grid6.style.cellPadding = PdfPaddings(top: 5);
  row11.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row11.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row11.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row11.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row11.cells[0].value = artesanoiD;
  row11.cells[1].value = curp;
  row11.cells[2].value = celular;

  grid6.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 260, page.getClientSize().width, page.getClientSize().height));

  grid7.columns.add(count: 1);
  PdfGridRow row12 = grid7.rows.add();
  grid7.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.dimGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 11));
  row12.cells[0].style.stringFormat =
      PdfStringFormat(alignment: PdfTextAlignment.center, wordSpacing: 5);

  row12.cells[0].value = 'REGISTRO';
  grid7.style.cellPadding = PdfPaddings(left: 5, top: 5);

  grid7.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 304, page.getClientSize().width, page.getClientSize().height));

  grid8.columns.add(count: 2);
  PdfGridRow row13 = grid8.rows.add();

  grid8.style.cellPadding = PdfPaddings(top: 5);
  row13.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row13.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row13.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row13.cells[0].value = 'FOLIO DE REGISTRO';
  row13.cells[1].value = 'NOMBRE DE TALLER O MARCA';

  PdfGridRow row14 = grid8.rows.add();

  grid8.style.cellPadding = PdfPaddings(top: 5);
  row14.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row14.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row14.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row14.cells[0].value = folio;
  row14.cells[1].value = marca;

  grid8.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 328, page.getClientSize().width, page.getClientSize().height));

  grid9.columns.add(count: 2);
  PdfGridRow row15 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row15.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row15.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row15.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row15.cells[0].value = 'RAMA ARTESANAL';
  row15.cells[1].value = 'DESCRIPCIÓN DE PRODUCTOS';

  PdfGridRow row16 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row16.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row16.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row16.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row16.cells[0].value = rama;
  row16.cells[1].value = descripcion;

  PdfGridRow row17 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row17.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row17.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row17.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row17.cells[0].value = "TIEMPO DE ANTIGUEDAD ELABORANDO ARTESANIAS";
  row17.cells[1].value = tiempo;

  PdfGridRow row18 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row18.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row18.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row18.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row18.cells[0].value = "¿CUENTA CON REGISTRO DE MARCA?";
  row18.cells[1].value = registro;

  PdfGridRow row19 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row19.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row19.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row19.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row19.cells[0].value = "¿CUENTA CON TERMINAL PUNTO DE VENTA?";
  row19.cells[1].value = terminal;

  PdfGridRow row20 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row20.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row20.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row20.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row20.cells[0].value = "¿CUENTA CON CERTIFICACION HECHA EN OAXACA?";
  row20.cells[1].value = certificacion;

  PdfGridRow row21 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row21.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row21.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row21.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row21.cells[0].value =
      "¿HA PARTICIPADO EN EDICIONES PASADAS DE LA EXPOFERIA GUELAGUETZA?";
  row21.cells[1].value = ediciones;

  PdfGridRow row22 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row22.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row22.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row22.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row22.cells[0].value =
      "¿PARTICIPA EN LA TIENDA ARIPO EN ALGUN OTRO ESPACIO DE VENTA ARTESANAL?";
  row22.cells[1].value = aripo;

  PdfGridRow row23 = grid9.rows.add();

  grid9.style.cellPadding = PdfPaddings(top: 5);
  row23.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row23.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row23.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row23.cells[0].value = "RECIBIO";
  row23.cells[1].value = "LUIS ALBERTO SANCHEZ SANTOS";

  grid9.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 370, page.getClientSize().width, page.getClientSize().height));

  List<int> bytes = await document.save();
  document.dispose();
  saveAndLaunchFile(bytes, "Registro_$folio.pdf");
}
