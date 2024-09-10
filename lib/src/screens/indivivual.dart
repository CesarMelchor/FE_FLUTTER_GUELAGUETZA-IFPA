import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guelaguetza/src/models/artesano.dart';
import 'package:guelaguetza/src/utils/firebase_config.dart';
import 'package:guelaguetza/src/utils/letter.dart';
import 'package:guelaguetza/src/utils/variables.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:vrouter/vrouter.dart';
import '../models/rama.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:guelaguetza/src/utils/mobile.dart'
    if (dart.library.html) 'package:guelaguetza/src/utils/web.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class IndividualRegisterScreen extends StatefulWidget {
  const IndividualRegisterScreen({super.key});

  @override
  State<IndividualRegisterScreen> createState() =>
      _IndividualRegisterScreenState();
}

class _IndividualRegisterScreenState extends State<IndividualRegisterScreen> {
  TextEditingController nombre = TextEditingController(text: Variables.nombre);
  TextEditingController paterno =
      TextEditingController(text: Variables.paterno);
  TextEditingController materno =
      TextEditingController(text: Variables.materno);

  TextEditingController curp = TextEditingController();
  TextEditingController movil = TextEditingController(text: Variables.movil);

  TextEditingController des1 = TextEditingController(text: Variables.des1);
  TextEditingController des2 = TextEditingController(text: Variables.des2);
  TextEditingController des3 = TextEditingController(text: Variables.des3);
  TextEditingController antiguedad =
      TextEditingController(text: Variables.antiguedad);
  TextEditingController marca = TextEditingController(text: Variables.marca);
  String folio = "";
  late Response response;
  late Response responseEtnia;
  late Response responseMunicipio;
  late Response responseRama;
  late Response responseRegion;

  var dio = Dio();

  List<Rama> _ramas = [];
  Artesano artesano = Artesano(
      idArtesano: "",
      nombre: "",
      primerApellido: "",
      segundoApellido: "",
      sexo: "",
      fechaNacimiento: "",
      edoCivil: "",
      curp: "",
      claveIne: "",
      rfc: "",
      calle: "",
      numExterior: "",
      numInterior: "",
      cp: "",
      idRegion: "",
      idMunicipio: "",
      idDistrito: "",
      localidad: "",
      seccion: "",
      telFijo: "",
      telCelular: "",
      correo: "",
      redesSociales: "",
      escolaridad: "",
      idGrupo: "",
      grupoPertenencia: "",
      idOrganizacion: "",
      idMateria: "",
      idVenta: "",
      idComprador: "",
      folioCuis: "",
      foto: "",
      activo: "",
      nombreArchivo: "",
      comentarios: "",
      createdAt: "",
      updatedAt: "");

  Future listRamas() async {
    responseRama = await dio.get("https://sistema-ioa.com/api/fast_query",
        queryParameters: {"consulta": "getRamas"});
    final result = responseRama.data;
    Iterable list = result['ramas'];
    _ramas = list.map<Rama>((json) => Rama.fromJson(json)).toList();
    return _ramas;
  }

  Future getData(curp) async {
    response = await dio.get("https://sistema-ioa.com/api/fast_query",
        queryParameters: {"consulta": "getDataArtesanoByCurp", "curp": curp});
    final result = response.data;
    artesano = Artesano.fromJson(result);
    setState(() {
      Variables.idArtesano = artesano.idArtesano;
      Variables.usuario = true;
      nombre.text = artesano.nombre;
      paterno.text = artesano.primerApellido;
      materno.text = artesano.segundoApellido;
      movil.text = artesano.telCelular;
      Variables.idArtesano = artesano.idArtesano;
      Variables.nombre = artesano.nombre;
      Variables.paterno = artesano.primerApellido;
      Variables.materno = artesano.segundoApellido;
      Variables.movil = artesano.telCelular;
      Variables.idArtesanoOrg = artesano.idOrganizacion;
      Variables.estado = artesano.idDistrito;
      Variables.municipio = artesano.idMunicipio;
      Variables.localidad = artesano.localidad;
      Variables.region = artesano.idRegion;
      Variables.numero = artesano.numExterior;
      Variables.calle = artesano.calle;
      Variables.cp = artesano.cp;
      Variables.curp = artesano.curp;
    });
  }

  Future registro(
      idArteno,
      nombre,
      paterno,
      materno,
      cel,
      ram1,
      ram2,
      ram3,
      des1,
      des2,
      des3,
      tiempo,
      marca,
      registro,
      terminal,
      certificacion,
      ediciones,
      tienda,
      credencia,
      cartaGrupo,
      pieza1,
      pieza2,
      pieza3,
      taller1,
      taller2,
      taller3,
      organizacion) async {
    response = await dio
        .get("https://sistema-ioa.com/api/fast_query", queryParameters: {
      "consulta": "registroGuelaguetza",
      "idArtesano": idArteno,
      "nombre": nombre,
      "paterno": paterno,
      "materno": materno,
      "celular": cel,
      "ram1": ram1,
      "ram2": ".",
      "ram3": ".",
      "des1": des1,
      "des2": ".",
      "des3": ".",
      "tiempo": tiempo,
      "marca": marca,
      "registro": registro,
      "terminal": terminal,
      "certificacion": certificacion,
      "ediciones": ediciones,
      "tienda": tienda,
      "credencial": credencia,
      "cartaGrupo": cartaGrupo,
      "pieza1": pieza1,
      "pieza2": pieza2,
      "pieza3": pieza3,
      "taller1": taller1,
      "taller2": taller2,
      "taller3": taller3,
      "organizacion": organizacion
    });

    setState(() {
      folio = response.data;
    });
    if (response.statusCode == 200) {
      setState(() {
        Variables.exito = true;
      });
      if (response.data == 'REP') {
        // ignore: use_build_context_synchronously
        AchievementView(
          context,
          title: "Aviso",
          subTitle: "Solo se permite una solicitud por persona.",
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.white,
          ),
          color: Colors.amber,
          textStyleTitle: const TextStyle(color: Colors.white),
          textStyleSubTitle: const TextStyle(color: Colors.white),
          alignment: Alignment.centerRight,
          duration: const Duration(seconds: 3),
          isCircle: true,
        ).show();
      } else if (response.data == "FIN"){
        
      // ignore: use_build_context_synchronously
      AchievementView(
        context,
        title: "Aviso",
        subTitle:
            "El periodo de registros ha finalizado.",
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.white,
        ),
        color: Colors.amber,
        textStyleTitle: const TextStyle(color: Colors.white),
        textStyleSubTitle: const TextStyle(color: Colors.white),
        alignment: Alignment.centerRight,
        duration: const Duration(seconds: 3),
        isCircle: true,
      ).show();
      }
       else {
        // ignore: use_build_context_synchronously
        _buildAlertDialog(context);
        _createPDF(folio, artesano.nombre, artesano.primerApellido,
            artesano.segundoApellido, artesano.curp);
        _createFicha(
            artesano.idArtesano,
            nombre,
            paterno,
            materno,
            artesano.fechaNacimiento,
            artesano.sexo,
            artesano.idGrupo,
            artesano.idRegion,
            artesano.idDistrito,
            artesano.idMunicipio,
            artesano.idMunicipio,
            artesano.calle,
            artesano.numExterior,
            artesano.cp,
            folio,
            curp,
            Variables.movil,
            marca,
            ram1,
            des1,
            tiempo,
            registro,
            terminal,
            certificacion,
            ediciones,
            tienda);
      }
    } else {
      // ignore: use_build_context_synchronously
      AchievementView(
        context,
        title: "Aviso",
        subTitle:
            "Hubo un error en la obtención de datos, inténtalo de nuevo más tarde.",
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
  }

  bool processing = false;
  late FirebaseApp app;
  FirebaseOptions get firebaseOptions => const FirebaseOptions(
        appId: "1:882379150768:web:d2cd64522151cfb0793275",
        apiKey: "AIzaSyDe3FMpiSlydNfKo6o8Nm08mC0wFi_b6ew",
        projectId: "ioa-documents",
        messagingSenderId: "882379150768",
      );

  Future<void> initializeDefault() async {
    app = await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions,
    );
    // ignore: avoid_print
    print('Initialized default app $app');
  }

  Future<void> initializeSecondary() async {
    FirebaseApp app =
        await Firebase.initializeApp(name: 'ioa', options: firebaseOptions);

    // ignore: avoid_print
    print('Initialized $app');
  }

  void apps() {
    final List<FirebaseApp> apps = Firebase.apps;
    // ignore: avoid_print
    print('Currently initialized apps: $apps');
  }

  void options() {
    final FirebaseApp app = Firebase.app('ioa');
    final options = app.options;
    // ignore: avoid_print
    print('Current options for app : $options');
  }

  Future<void> delete(name) async {
    final FirebaseApp app = Firebase.app(name);
    await app.delete();
    // ignore: avoid_print
    print('App  deleted');
  }

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
    return FutureBuilder(
      future: listRamas(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Scaffold(
                body: responsive == false
                    ? ListView(
                        children: [
                          Container(
                              width: Adaptive.w(100),
                              height: Adaptive.h(10),
                              color: Variables.colorMorado,
                              child: Center(
                                  child: Text(
                                "REGISTRO DE INFORMACIÓN INDIVIDUAL",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayRegular,
                                    fontSize: Adaptive.sp(13),
                                    color: Colors.white),
                              ))),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/logo_artesanias.png",
                                      width: Adaptive.w(23),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: Adaptive.h(17),
                                    ),
                                    SizedBox(
                                      width: Adaptive.w(30),
                                      child: TextFormField(
                                        inputFormatters: [
                                          CapitalLetters(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9a-zA-ZñÑ]"))
                                        ],
                                        controller: curp,
                                        onChanged: (value) {
                                          setState(() {
                                            Variables.curp = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Variables.colorAzul),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Variables
                                                      .borderRadiusInput))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Variables.colorGris),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Variables
                                                      .borderRadiusInput))),
                                          floatingLabelStyle: TextStyle(
                                              color: Variables.colorAzul),
                                          label: const Text("CURP"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(3),
                                    ),
                                    SizedBox(
                                      width: Adaptive.w(30),
                                      child: TextFormField(
                                        inputFormatters: [
                                          CapitalLetters(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9a-zA-ZñÑ ]"))
                                        ],
                                        controller: nombre,
                                        onChanged: (value) {
                                          setState(() {
                                            Variables.nombre = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Variables.colorAzul),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(Variables
                                                        .borderRadiusInput))),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Variables.colorGris),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(Variables
                                                        .borderRadiusInput))),
                                            floatingLabelStyle: TextStyle(
                                                color: Variables.colorAzul),
                                            label: const Text("NOMBRE")),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.3),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "assets/images/logo_guelaguetza.png",
                                      width: Adaptive.w(17),
                                    ),
                                    SizedBox(
                                        width: Adaptive.w(20),
                                        height: Adaptive.h(6),
                                        child: OutlinedButton(
                                            onPressed: () {
                                              if (Variables.curp.length == 18) {
                                                getData(Variables.curp);
                                              } else {
                                                AchievementView(
                                                  context,
                                                  title: "Aviso",
                                                  subTitle:
                                                      "Ingresa una CURP válida.",
                                                  icon: const Icon(
                                                    Icons.warning_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  color: Colors.amber,
                                                  textStyleTitle:
                                                      const TextStyle(
                                                          color: Colors.white),
                                                  textStyleSubTitle:
                                                      const TextStyle(
                                                          color: Colors.white),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  isCircle: true,
                                                ).show();
                                              }
                                            },
                                            child: Text(
                                              "Obtener datos",
                                              style: TextStyle(
                                                  color: Variables.colorAzul),
                                            ))),
                                    SizedBox(
                                      height: Adaptive.h(3),
                                    ),
                                    SizedBox(
                                      width: Adaptive.w(30),
                                      child: TextFormField(
                                        inputFormatters: [
                                          CapitalLetters(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9a-zA-ZñÑ ]"))
                                        ],
                                        controller: paterno,
                                        onChanged: (value) {
                                          setState(() {
                                            Variables.paterno = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Variables.colorAzul),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(Variables
                                                        .borderRadiusInput))),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Variables.colorGris),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(Variables
                                                        .borderRadiusInput))),
                                            floatingLabelStyle: TextStyle(
                                                color: Variables.colorAzul),
                                            label: const Text("APELLIDO PATERNO")),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                  width: Adaptive.w(25),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: materno,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.materno = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("APELLIDO MATERNO")),
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, Adaptive.h(3.5), 0, 0),
                                  child: SizedBox(
                                    width: Adaptive.w(25),
                                    child: TextFormField(
                                      inputFormatters: [
                                        CapitalLetters(),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9]"))
                                      ],
                                      controller: movil,
                                      maxLength: 10,
                                      onChanged: (value) {
                                        setState(() {
                                          Variables.movil = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        label: const Text("TELEFONO MOVIL"),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(30),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: marca,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.marca = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("NOMBRE DEL TALLER O MARCA")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: Adaptive.w(30),
                                    child: CustomSearchableDropDown(
                                        menuPadding: EdgeInsets.symmetric(
                                            horizontal: Adaptive.w(15)),
                                        items: _ramas,
                                        label: 'RAMA ARTESANAL',
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                            border: Border.all(
                                                color: Variables.colorAzul)),
                                        dropDownMenuItems: _ramas.map((item) {
                                          return item.nombreRama;
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            Variables.rama1 = value.idRama;
                                          }
                                        })
                                        ),
                                SizedBox(
                                  width: Adaptive.w(5),
                                ),
                                SizedBox(
                                  width: Adaptive.w(40),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: des1,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.des1 = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("PRODUCTOS")),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Adaptive.w(20),
                                  child: TextFormField(
                                    maxLength: 2,
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]"))
                                    ],
                                    controller: antiguedad,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.antiguedad = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(Radius.circular(
                                                Variables.borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text(
                                            "TIEMPO DE ANTIGUEDAD ELABORANDO ARTESANIAS")),
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(20),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.registroMarca =
                                            item.toString();
                                      });
                                    },
                                    label: "¿CUENTA CON REGISTRO DE MARCA?",
                                    selectedItem: Variables.registroMarca,
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(20),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.terminalVenta =
                                            item.toString();
                                      });
                                    },
                                    label:
                                        "¿CUENTA CON TERMINAL PUNTO DE VENTA?",
                                    selectedItem: Variables.terminalVenta,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Adaptive.w(30),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    label:
                                        "¿CUENTA CON CERTIFICACION HECHO EN OAXACA",
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.certificacionOaxaca =
                                            item.toString();
                                      });
                                    },
                                    selectedItem: Variables.certificacionOaxaca,
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(2),
                                ),
                                SizedBox(
                                  width: Adaptive.w(30),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    label:
                                        "¿HA PARTICIPADO EN EDICIONES PASADAS DE EXPOFERIA OAXACA?",
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.participacionPasada =
                                            item.toString();
                                      });
                                    },
                                    selectedItem: Variables.participacionPasada,
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(2),
                                ),
                                SizedBox(
                                  width: Adaptive.w(30),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    label:
                                        "¿PARTICIPA EN LA TIENDA ARIPO O EN ALGUN OTRO ESPACIO DE VENTA ARTESANAL?",
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.aripo = item.toString();
                                      });
                                    },
                                    selectedItem: Variables.aripo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              children: [
                                const Text("CREDENCIAL VIGENTE IFPA : "),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      initializeDefault();
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);

                                      if (result == null) return;
                                      // ignore: use_build_context_synchronously
                                      _buildAlertDialogLoading(context);

                                      final file = result.files.first;
                                      final fileBytes =
                                          result.files.first.bytes;

                                      String fileName = file.name;
                                      if (file.size < 2097152) {
                                        if (fileName.contains(".pdf")) {
                                          setState(() {
                                            processing = true;
                                          });
                                          await FirebaseStorage.instance
                                              .ref('files/$fileName')
                                              .putData(fileBytes!);
                                          String namePath =
                                              await FirebaseStorage.instance
                                                  .ref('files/$fileName')
                                                  .getDownloadURL();
                                          setState(() {
                                            Variables.nameFileCredencial =
                                                file.name;
                                            Variables.pathFileCredencial =
                                                namePath;
                                          });

                                          setState(() {
                                            processing = false;
                                            Variables.archivo1 = true;
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          AchievementView(
                                            context,
                                            title: "Aviso",
                                            subTitle:
                                                "El formato de tu CURP debe estar en PDF.",
                                            icon: const Icon(
                                              Icons.warning_rounded,
                                              color: Colors.white,
                                            ),
                                            color: Colors.amber,
                                            textStyleTitle: const TextStyle(
                                                color: Colors.white),
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        AchievementView(
                                          context,
                                          title: "Aviso",
                                          subTitle:
                                              "El tamaño del archivo no debe ser mayor a 2 MB.",
                                          icon: const Icon(
                                            Icons.warning_rounded,
                                            color: Colors.white,
                                          ),
                                          color: Colors.amber,
                                          textStyleTitle: const TextStyle(
                                              color: Colors.white),
                                          textStyleSubTitle: const TextStyle(
                                              color: Colors.white),
                                          alignment: Alignment.centerRight,
                                          duration: const Duration(seconds: 3),
                                          isCircle: true,
                                        ).show();
                                      }
                                    },
                                    child: Text(
                                      "BUSCAR",
                                      style:
                                          TextStyle(color: Variables.colorAzul),
                                    )),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.archivo1 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(5),
                                ),
                                const Text(
                                    "CARTA DE GRUPO ARTESANAL (OPCIONAL) : "),
                                SizedBox(
                                  width: Adaptive.w(3),
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      initializeDefault();
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);

                                      if (result == null) return;

                                      // ignore: use_build_context_synchronously
                                      _buildAlertDialogLoading(context);

                                      final file = result.files.first;
                                      final fileBytes =
                                          result.files.first.bytes;
                                      String fileName = file.name;

                                      if (file.size < 2097152) {
                                        if (fileName.contains(".pdf")) {
                                          setState(() {
                                            processing = true;
                                          });
                                          await FirebaseStorage.instance
                                              .ref('files/$fileName')
                                              .putData(fileBytes!);
                                          String namePath =
                                              await FirebaseStorage.instance
                                                  .ref('files/$fileName')
                                                  .getDownloadURL();
                                          setState(() {
                                            Variables.nameFileCarta = file.name;
                                            Variables.pathFileCarta = namePath;
                                          });

                                          setState(() {
                                            processing = false;
                                            Variables.archivo2 = true;
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        AchievementView(
                                          context,
                                          title: "Aviso",
                                          subTitle:
                                              "El tamaño del archivo no debe ser mayor a 2 MB.",
                                          icon: const Icon(
                                            Icons.warning_rounded,
                                            color: Colors.white,
                                          ),
                                          color: Colors.amber,
                                          textStyleTitle: const TextStyle(
                                              color: Colors.white),
                                          textStyleSubTitle: const TextStyle(
                                              color: Colors.white),
                                          alignment: Alignment.centerRight,
                                          duration: const Duration(seconds: 3),
                                          isCircle: true,
                                        ).show();
                                      }
                                    },
                                    child: Text(
                                      "BUSCAR",
                                      style:
                                          TextStyle(color: Variables.colorAzul),
                                    )),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.archivo2 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Center(child: Text("FOTOGRAFIAS DE PIEZAS")),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;

                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFilePieza1 =
                                                  file.name;
                                              Variables.pathFilePieza1 =
                                                  namePath;
                                              Variables.foto1 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto1 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;

                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFilePieza2 =
                                                  file.name;
                                              Variables.pathFilePieza2 =
                                                  namePath;
                                              Variables.foto2 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto2 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFilePieza3 =
                                                  file.name;
                                              Variables.pathFilePieza3 =
                                                  namePath;
                                              Variables.foto3 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto3 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Center(child: Text("FOTOGRAFIAS DE TALLER")),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFileTaller1 =
                                                  file.name;
                                              Variables.pathFileTaller1 =
                                                  namePath;
                                              Variables.foto4 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto4 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFileTaller2 =
                                                  file.name;
                                              Variables.pathFileTaller2 =
                                                  namePath;
                                              Variables.foto5 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto5 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFileTaller3 =
                                                  file.name;
                                              Variables.pathFileTaller3 =
                                                  namePath;
                                              Variables.foto6 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto6 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(6),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: Adaptive.w(35),
                                  height: Adaptive.h(7),
                                  child: OutlinedButton(
                                      onPressed: () {
                                        if (Variables.usuario == true) {
                                          if (Variables.movil != "" &&
                                              Variables.marca != "" &&
                                              Variables.rama1 != "" &&
                                              Variables.des1 != "" &&
                                              Variables.movil != "" &&
                                              Variables.antiguedad != "" &&
                                              Variables.registroMarca !=
                                                  "SELECCIONAR" &&
                                              Variables.terminalVenta !=
                                                  "SELECCIONAR" &&
                                              Variables.certificacionOaxaca !=
                                                  "SELECCIONAR" &&
                                              Variables.participacionPasada !=
                                                  "SELECCIONAR" &&
                                              Variables.aripo !=
                                                  "SELECCIONAR") {
                                            if (Variables.archivo1 == false ||
                                                Variables.foto1 == false ||
                                                Variables.foto2 == false ||
                                                Variables.foto3 == false ||
                                                Variables.foto4 == false ||
                                                Variables.foto5 == false ||
                                                Variables.foto6 == false) {
                                              AchievementView(
                                                context,
                                                title: "Aviso",
                                                subTitle:
                                                    "Debes enviar todos los archivos solicitados.",
                                                icon: const Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.white,
                                                ),
                                                color: Colors.amber,
                                                textStyleTitle: const TextStyle(
                                                    color: Colors.white),
                                                textStyleSubTitle:
                                                    const TextStyle(
                                                        color: Colors.white),
                                                alignment:
                                                    Alignment.centerRight,
                                                duration:
                                                    const Duration(seconds: 3),
                                                isCircle: true,
                                              ).show();
                                            } else {
                                              realizarRegistro();
                                              apps();
                                            }
                                          } else {
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "Completa todos los campos.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.amber,
                                              ),
                                              color: Colors.blue,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        } else {
                                          AchievementView(
                                            context,
                                            title: "Aviso",
                                            subTitle:
                                                "Debes dar click en el botón Obtener datos.",
                                            icon: const Icon(
                                              Icons.warning_rounded,
                                              color: Colors.white,
                                            ),
                                            color: Colors.blue,
                                            textStyleTitle: const TextStyle(
                                                color: Colors.white),
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: Variables.botonGuelaguetza,
                                      child: const Text("ENVIAR"))),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(6),
                          )
                        ],
                      )
                    :

                    //elementos de celular

                    ListView(
                        children: [
                          Container(
                              width: Adaptive.w(100),
                              height: Adaptive.h(10),
                              color: Variables.colorMorado,
                              child: Center(
                                  child: Text(
                                "REGISTRO DE INFORMACIÓN INDIVIDUAL",
                                style: TextStyle(
                                    fontFamily: Variables.fontPlayRegular,
                                    fontSize: Adaptive.sp(15),
                                    color: Colors.white),
                              ))),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            "assets/images/logo_artesanias.png",
                            height: Adaptive.h(20),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ]"))
                                    ],
                                    controller: curp,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.curp = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Variables.colorAzul),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Variables
                                                  .borderRadiusInput))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Variables.colorGris),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Variables
                                                  .borderRadiusInput))),
                                      floatingLabelStyle:
                                          TextStyle(color: Variables.colorAzul),
                                      label: const Text("CURP"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                    width: Adaptive.w(50),
                                    height: Adaptive.h(6),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          if (Variables.curp.length == 18) {
                                            getData(Variables.curp);
                                          } else {
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "Ingresa una CURP válida.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text(
                                          "Obtener datos",
                                          style: TextStyle(
                                              color: Variables.colorAzul),
                                        ))),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: nombre,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.nombre = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("NOMBRE")),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.w(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: paterno,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.paterno = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("APELLIDO PATERNO")),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: materno,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.materno = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("APELLIDO MATERNO")),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]"))
                                    ],
                                    controller: movil,
                                    maxLength: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.movil = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      label: const Text("TELEFONO MOVIL"),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Variables.colorAzul),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Variables
                                                  .borderRadiusInput))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Variables.colorGris),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Variables
                                                  .borderRadiusInput))),
                                      floatingLabelStyle:
                                          TextStyle(color: Variables.colorAzul),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: marca,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.marca = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("NOMBRE DEL TALLER O MARCA")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                    width: Adaptive.w(80),
                                    child: CustomSearchableDropDown(
                                        menuPadding: EdgeInsets.symmetric(
                                            horizontal: Adaptive.w(5)),
                                        items: _ramas,
                                        label: 'RAMA ARTESANAL',
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                            border: Border.all(
                                                color: Variables.colorAzul)),
                                        dropDownMenuItems: _ramas.map((item) {
                                          return item.nombreRama;
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            Variables.rama1 = value.idRama;
                                          }
                                        })),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-ZñÑ ]"))
                                    ],
                                    controller: des1,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.des1 = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text("PRODUCTOS")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: TextFormField(
                                    maxLength: 2,
                                    inputFormatters: [
                                      CapitalLetters(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]"))
                                    ],
                                    controller: antiguedad,
                                    onChanged: (value) {
                                      setState(() {
                                        Variables.antiguedad = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorAzul),
                                            borderRadius: BorderRadius.all(Radius.circular(
                                                Variables.borderRadiusInput))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Variables.colorGris),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Variables
                                                    .borderRadiusInput))),
                                        floatingLabelStyle: TextStyle(
                                            color: Variables.colorAzul),
                                        label: const Text(
                                            "TIEMPO DE ANTIGUEDAD ELABORANDO ARTESANIAS")),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.registroMarca =
                                            item.toString();
                                      });
                                    },
                                    label: "¿CUENTA CON REGISTRO DE MARCA?",
                                    selectedItem: Variables.registroMarca,
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.terminalVenta =
                                            item.toString();
                                      });
                                    },
                                    label:
                                        "¿CUENTA CON TERMINAL PUNTO DE VENTA?",
                                    selectedItem: Variables.terminalVenta,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    label:
                                        "¿CUENTA CON CERTIFICACION HECHO EN OAXACA",
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.certificacionOaxaca =
                                            item.toString();
                                      });
                                    },
                                    selectedItem: Variables.certificacionOaxaca,
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    label:
                                        "¿HA PARTICIPADO EN EDICIONES PASADAS DE EXPOFERIA OAXACA?",
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.participacionPasada =
                                            item.toString();
                                      });
                                    },
                                    selectedItem: Variables.participacionPasada,
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                SizedBox(
                                  width: Adaptive.w(80),
                                  child: FindDropdown(
                                    showSearchBox: false,
                                    items: const ["SI", "NO"],
                                    label:
                                        "¿PARTICIPA EN LA TIENDA ARIPO O EN ALGUN OTRO ESPACIO DE VENTA ARTESANAL?",
                                    // ignore: avoid_print
                                    onChanged: (item) {
                                      setState(() {
                                        Variables.aripo = item.toString();
                                      });
                                    },
                                    selectedItem: Variables.aripo,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text("CREDENCIAL VIGENTE IFPA : "),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      initializeDefault();
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);

                                      if (result == null) return;
                                      // ignore: use_build_context_synchronously
                                      _buildAlertDialogLoading(context);

                                      final file = result.files.first;
                                      final fileBytes =
                                          result.files.first.bytes;

                                      String fileName = file.name;
                                      if (file.size < 2097152) {
                                        if (fileName.contains(".pdf")) {
                                          setState(() {
                                            processing = true;
                                          });
                                          await FirebaseStorage.instance
                                              .ref('files/$fileName')
                                              .putData(fileBytes!);
                                          String namePath =
                                              await FirebaseStorage.instance
                                                  .ref('files/$fileName')
                                                  .getDownloadURL();
                                          setState(() {
                                            Variables.nameFileCredencial =
                                                file.name;
                                            Variables.pathFileCredencial =
                                                namePath;
                                          });

                                          setState(() {
                                            processing = false;
                                            Variables.archivo1 = true;
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          AchievementView(
                                            context,
                                            title: "Aviso",
                                            subTitle:
                                                "El formato de tu CURP debe estar en PDF.",
                                            icon: const Icon(
                                              Icons.warning_rounded,
                                              color: Colors.white,
                                            ),
                                            color: Colors.amber,
                                            textStyleTitle: const TextStyle(
                                                color: Colors.white),
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        AchievementView(
                                          context,
                                          title: "Aviso",
                                          subTitle:
                                              "El tamaño del archivo no debe ser mayor a 2 MB.",
                                          icon: const Icon(
                                            Icons.warning_rounded,
                                            color: Colors.white,
                                          ),
                                          color: Colors.amber,
                                          textStyleTitle: const TextStyle(
                                              color: Colors.white),
                                          textStyleSubTitle: const TextStyle(
                                              color: Colors.white),
                                          alignment: Alignment.centerRight,
                                          duration: const Duration(seconds: 3),
                                          isCircle: true,
                                        ).show();
                                      }
                                    },
                                    child: Text(
                                      "BUSCAR",
                                      style:
                                          TextStyle(color: Variables.colorAzul),
                                    )),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.archivo1 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                const Text(
                                    "CARTA DE GRUPO ARTESANAL (OPCIONAL) : "),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      initializeDefault();
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);

                                      if (result == null) return;

                                      // ignore: use_build_context_synchronously
                                      _buildAlertDialogLoading(context);

                                      final file = result.files.first;
                                      final fileBytes =
                                          result.files.first.bytes;
                                      String fileName = file.name;

                                      if (file.size < 2097152) {
                                        if (fileName.contains(".pdf")) {
                                          setState(() {
                                            processing = true;
                                          });
                                          await FirebaseStorage.instance
                                              .ref('files/$fileName')
                                              .putData(fileBytes!);
                                          String namePath =
                                              await FirebaseStorage.instance
                                                  .ref('files/$fileName')
                                                  .getDownloadURL();
                                          setState(() {
                                            Variables.nameFileCarta = file.name;
                                            Variables.pathFileCarta = namePath;
                                          });

                                          setState(() {
                                            processing = false;
                                            Variables.archivo2 = true;
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        AchievementView(
                                          context,
                                          title: "Aviso",
                                          subTitle:
                                              "El tamaño del archivo no debe ser mayor a 2 MB.",
                                          icon: const Icon(
                                            Icons.warning_rounded,
                                            color: Colors.white,
                                          ),
                                          color: Colors.amber,
                                          textStyleTitle: const TextStyle(
                                              color: Colors.white),
                                          textStyleSubTitle: const TextStyle(
                                              color: Colors.white),
                                          alignment: Alignment.centerRight,
                                          duration: const Duration(seconds: 3),
                                          isCircle: true,
                                        ).show();
                                      }
                                    },
                                    child: Text(
                                      "BUSCAR",
                                      style:
                                          TextStyle(color: Variables.colorAzul),
                                    )),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.archivo2 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          const Center(child: Text("FOTOGRAFIAS DE PIEZAS")),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;

                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFilePieza1 =
                                                  file.name;
                                              Variables.pathFilePieza1 =
                                                  namePath;
                                              Variables.foto1 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto1 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;

                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFilePieza2 =
                                                  file.name;
                                              Variables.pathFilePieza2 =
                                                  namePath;
                                              Variables.foto2 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto2 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFilePieza3 =
                                                  file.name;
                                              Variables.pathFilePieza3 =
                                                  namePath;
                                              Variables.foto3 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto3 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Center(child: Text("FOTOGRAFIAS DE TALLER")),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFileTaller1 =
                                                  file.name;
                                              Variables.pathFileTaller1 =
                                                  namePath;
                                              Variables.foto4 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto4 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFileTaller2 =
                                                  file.name;
                                              Variables.pathFileTaller2 =
                                                  namePath;
                                              Variables.foto5 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto5 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: Adaptive.w(1.5),
                                ),
                                SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          initializeDefault();
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) return;
                                          // ignore: use_build_context_synchronously
                                          _buildAlertDialogLoading(context);

                                          final file = result.files.first;
                                          final fileBytes =
                                              result.files.first.bytes;
                                          String fileName = file.name;
                                          if (file.size < 2097152) {
                                            await FirebaseStorage.instance
                                                .ref('files/$fileName')
                                                .putData(fileBytes!);
                                            String namePath =
                                                await FirebaseStorage.instance
                                                    .ref('files/$fileName')
                                                    .getDownloadURL();
                                            setState(() {
                                              Variables.nameFileTaller3 =
                                                  file.name;
                                              Variables.pathFileTaller3 =
                                                  namePath;
                                              Variables.foto6 = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
// ignore: use_build_context_synchronously
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "El tamaño del archivo no debe ser mayor a 2 MB.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color: Colors.amber,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        },
                                        child: Text("BUSCAR",
                                            style: TextStyle(
                                                color: Variables.colorAzul)))),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Variables.foto6 == false
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(6),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: Adaptive.w(35),
                                  height: Adaptive.h(7),
                                  child: OutlinedButton(
                                      onPressed: () {
                                        if (Variables.usuario == true) {
                                          if (Variables.movil != "" &&
                                              Variables.marca != "" &&
                                              Variables.rama1 != "" &&
                                              Variables.des1 != "" &&
                                              Variables.movil != "" &&
                                              Variables.antiguedad != "" &&
                                              Variables.registroMarca !=
                                                  "SELECCIONAR" &&
                                              Variables.terminalVenta !=
                                                  "SELECCIONAR" &&
                                              Variables.certificacionOaxaca !=
                                                  "SELECCIONAR" &&
                                              Variables.participacionPasada !=
                                                  "SELECCIONAR" &&
                                              Variables.aripo !=
                                                  "SELECCIONAR") {
                                            if (Variables.archivo1 == false ||
                                                Variables.foto1 == false ||
                                                Variables.foto2 == false ||
                                                Variables.foto3 == false ||
                                                Variables.foto4 == false ||
                                                Variables.foto5 == false ||
                                                Variables.foto6 == false) {
                                              AchievementView(
                                                context,
                                                title: "Aviso",
                                                subTitle:
                                                    "Debes enviar todos los archivos solicitados.",
                                                icon: const Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.white,
                                                ),
                                                color: Colors.amber,
                                                textStyleTitle: const TextStyle(
                                                    color: Colors.white),
                                                textStyleSubTitle:
                                                    const TextStyle(
                                                        color: Colors.white),
                                                alignment:
                                                    Alignment.centerRight,
                                                duration:
                                                    const Duration(seconds: 3),
                                                isCircle: true,
                                              ).show();
                                            } else {
                                              realizarRegistro();
                                              apps();
                                            }
                                          } else {
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "Completa todos los campos.",
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.amber,
                                              ),
                                              color: Colors.blue,
                                              textStyleTitle: const TextStyle(
                                                  color: Colors.white),
                                              textStyleSubTitle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              alignment: Alignment.centerRight,
                                              duration:
                                                  const Duration(seconds: 3),
                                              isCircle: true,
                                            ).show();
                                          }
                                        } else {
                                          AchievementView(
                                            context,
                                            title: "Aviso",
                                            subTitle:
                                                "Debes dar click en el botón Obtener datos.",
                                            icon: const Icon(
                                              Icons.warning_rounded,
                                              color: Colors.white,
                                            ),
                                            color: Colors.blue,
                                            textStyleTitle: const TextStyle(
                                                color: Colors.white),
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: Variables.botonGuelaguetza,
                                      child: const Text("ENVIAR"))),
                              SizedBox(
                                height: Adaptive.h(5),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(6),
                          )
                        ],
                      ))
            : Center(
                child: Image.asset("assets/images/cargando.gif"),
              );
      },
    );
  }

  void realizarRegistro() {
    registro(
        artesano.idArtesano,
        artesano.nombre,
        artesano.primerApellido,
        artesano.segundoApellido,
        Variables.movil,
        Variables.rama1,
        Variables.rama2,
        Variables.rama3,
        Variables.des1,
        Variables.des2,
        Variables.des3,
        Variables.antiguedad,
        Variables.marca,
        Variables.registroMarca,
        Variables.terminalVenta,
        Variables.certificacionOaxaca,
        Variables.participacionPasada,
        Variables.aripo,
        Variables.pathFileCredencial,
        Variables.pathFileCarta,
        Variables.pathFilePieza1,
        Variables.pathFilePieza2,
        Variables.pathFilePieza3,
        Variables.pathFileTaller1,
        Variables.pathFileTaller2,
        Variables.pathFileTaller3,
        artesano.idOrganizacion);
  }

  _buildAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("REGISTRO EXITOSO"),
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(10)),
            content: Column(
              children: [
                Text(
                  "A continuación se descargarán dos archivos en su dispositivo.",
                  style: TextStyle(
                      fontFamily: Variables.fontPlayItalic, fontSize: 18),
                ),
                SizedBox(
                  height: Adaptive.h(1.5),
                ),
                Text(
                  "Permite que el navegador pueda descargarlos.",
                  style: TextStyle(
                      fontFamily: Variables.fontPlayItalic, fontSize: 18),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: Variables.raisedButtonStyle,
                      onPressed: () {
                        setState(() {
                          Variables.exito = false;
                          artesano = Artesano(
                              idArtesano: "",
                              nombre: "",
                              primerApellido: "",
                              segundoApellido: "",
                              sexo: "",
                              fechaNacimiento: "",
                              edoCivil: "",
                              curp: "",
                              claveIne: "",
                              rfc: "",
                              calle: "",
                              numExterior: "",
                              numInterior: "",
                              cp: "",
                              idRegion: "",
                              idMunicipio: "",
                              idDistrito: "",
                              localidad: "",
                              seccion: "",
                              telFijo: "",
                              telCelular: "",
                              correo: "",
                              redesSociales: "",
                              escolaridad: "",
                              idGrupo: "",
                              grupoPertenencia: "",
                              idOrganizacion: "",
                              idMateria: "",
                              idVenta: "",
                              idComprador: "",
                              folioCuis: "",
                              foto: "",
                              activo: "",
                              nombreArchivo: "",
                              comentarios: "",
                              createdAt: "",
                              updatedAt: "");
                          Variables.movil = '';
                          Variables.idArtesano = '';
                          Variables.rama1 = '';
                          Variables.des1 = '';
                          Variables.antiguedad = '.';
                          Variables.marca = '.';
                          Variables.registroMarca = 'BUSCAR';
                          Variables.terminalVenta = 'BUSCAR';
                          Variables.certificacionOaxaca = 'BUSCAR';
                          Variables.participacionPasada = 'BUSCAR';
                          Variables.aripo = 'BUSCAR';
                          Variables.pathFileCredencial = '';
                          Variables.pathFileCarta = '';
                          Variables.pathFilePieza1 = '';
                          Variables.pathFilePieza2 = '';
                          Variables.pathFilePieza3 = '';
                          Variables.pathFileTaller1 = '';
                          Variables.pathFileTaller2 = '';
                          Variables.pathFileTaller3 = '';
                          Variables.foto1 = false;
                          Variables.foto2 = false;
                          Variables.foto3 = false;
                          Variables.foto4 = false;
                          Variables.foto5 = false;
                          Variables.foto6 = false;
                          Variables.archivo1 = false;
                          Variables.archivo2 = false;
                          Variables.avisoPrivacidad = false;
                          Variables.idArtesano = artesano.idArtesano;
                          Variables.nombre = "";
                          Variables.paterno = "";
                          Variables.materno = "";
                          Variables.movil = "";
                          Variables.idArtesanoOrg = "";
                          Variables.estado = "";
                          Variables.municipio = "";
                          Variables.localidad = "";
                          Variables.region = "";
                          Variables.numero = "";
                          Variables.calle = "";
                          Variables.cp = "";
                          Variables.curp = "";
                          Variables.usuario = false;
                        });

                        Navigator.pop(context);
                        context.vRouter.to('/home');
                      },
                      child: Text(
                        "Finalizar",
                        style: TextStyle(
                            fontFamily: Variables.fontPlayItalic, fontSize: 18),
                      )),
                  SizedBox(
                    width: Adaptive.w(1.5),
                  ),
                  ElevatedButton(
                      style: Variables.raisedButtonStyle,
                      child: Text(
                        "Descargar",
                        style: TextStyle(
                            fontFamily: Variables.fontPlayItalic, fontSize: 18),
                      ),
                      onPressed: () {
                        _createPDF(
                            folio,
                            artesano.nombre,
                            artesano.primerApellido,
                            artesano.segundoApellido,
                            artesano.curp);
                        _createFicha(
                            Variables.idArtesano,
                            Variables.nombre,
                            Variables.paterno,
                            Variables.materno,
                            Variables.fechaNacimiento,
                            Variables.sexo,
                            artesano.idGrupo,
                            Variables.region,
                            Variables.estado,
                            Variables.municipio,
                            Variables.localidad,
                            Variables.calle,
                            Variables.numero,
                            Variables.cp,
                            folio,
                            Variables.curp,
                            Variables.movil,
                            Variables.marca,
                            Variables.rama1,
                            Variables.des1,
                            Variables.antiguedad,
                            Variables.registroMarca,
                            Variables.terminalVenta,
                            Variables.certificacionOaxaca,
                            Variables.participacionPasada,
                            Variables.aripo);
                      }),
                ],
              ),
            ],
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
            title: const Text("SUBIENDO..."),
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
