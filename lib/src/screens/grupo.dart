import 'package:achievement_view/achievement_view.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guelaguetza/src/models/organizacion.dart';
import 'package:guelaguetza/src/models/rama.dart';
import 'package:guelaguetza/src/utils/firebase_config.dart';
import 'package:guelaguetza/src/utils/mobile.dart'
    if (dart.library.html) 'package:guelaguetza/src/utils/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vrouter/vrouter.dart';
import '../utils/letter.dart';
import '../utils/variables.dart';

class GrupoRegisterScreen extends StatefulWidget {
  const GrupoRegisterScreen({super.key});

  @override
  State<GrupoRegisterScreen> createState() => _GrupoRegisterScreenState();
}

class _GrupoRegisterScreenState extends State<GrupoRegisterScreen> {
  TextEditingController nombre =
      TextEditingController(text: Variables.nombreOrganizacion);
  TextEditingController representante =
      TextEditingController(text: Variables.representanteOrganizacion);
  TextEditingController folioGrupo =
      TextEditingController(text: Variables.folioGrupo);
  TextEditingController grupodes1 =
      TextEditingController(text: Variables.grupodes1);
  TextEditingController grupodes2 =
      TextEditingController(text: Variables.grupodes2);
  TextEditingController grupodes3 =
      TextEditingController(text: Variables.grupodes3);
  TextEditingController antiguedad =
      TextEditingController(text: Variables.antiguedad);
  TextEditingController marca = TextEditingController(text: Variables.marca);
  TextEditingController movil = TextEditingController(text: Variables.movil);
  ScrollController scrol1 = ScrollController();
  ScrollController scrol2 = ScrollController();
  late Response response;
  late Response responseOrganizaciones;

  List<Rama> _ramas = [];
  List<Organizacion> _organizaciones = [];

  var dio = Dio();
  Organizacion organizacion = Organizacion(
      idGrupo: "",
      representante: "",
      nombreOrganizacion: "",
      calle: "",
      numeroExterior: "",
      cp: "",
      region: "",
      distrito: "",
      municipio: "",
      localidad: "");

  bool processing = false;

  late Response responseRama;

  Future listRamas() async {
    responseRama = await dio.get("https://sistema-ioa.com/api/fast_query",
        queryParameters: {"consulta": "getRamas"});
    final result = responseRama.data;
    Iterable list = result['ramas'];
    _ramas = list.map<Rama>((json) => Rama.fromJson(json)).toList();
    return _ramas;
  }

  Future listOrganizaciones() async {
    responseOrganizaciones = await dio.get(
        "https://sistema-ioa.com/api/fast_query",
        queryParameters: {"consulta": "getOrganizaciones"});
    final result = responseOrganizaciones.data;
    Iterable list = result['organizaciones'];
    _organizaciones =
        list.map<Organizacion>((json) => Organizacion.fromJson(json)).toList();
    return _organizaciones;
  }

  Future registro(
      idGrupo,
      nombre,
      representante,
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
      pieza1,
      pieza2,
      pieza3,
      taller1,
      taller2,
      taller3) async {
    response = await dio
        .get("https://sistema-ioa.com/api/fast_query", queryParameters: {
      "consulta": "registroGuelaguetzaGrupo",
      "idGrupo": idGrupo,
      "nombre": nombre,
      "representante": representante,
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
      "pieza1": pieza1,
      "pieza2": pieza2,
      "pieza3": pieza3,
      "taller1": taller1,
      "taller2": taller2,
      "taller3": taller3,
    });

    setState(() {
      Variables.folioGrupo = response.data;
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
          subTitle: "Solo se permite una solicitud por grupo.",
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
      } else {
        // ignore: use_build_context_synchronously
        _buildAlertDialog(context);
        _createPDF(response.data, Variables.nombreOrganizacion);
        _createFicha(
            Variables.nombreOrganizacion,
            Variables.representanteOrganizacion,
            Variables.region,
            Variables.estado,
            Variables.municipio,
            Variables.localidad,
            Variables.calle,
            Variables.numero,
            Variables.cp,
            Variables.folioGrupo,
            Variables.movil,
            Variables.marca,
            Variables.rama1,
            Variables.grupodes1,
            Variables.antiguedad,
            Variables.registroMarca,
            Variables.terminalVenta,
            Variables.certificacionOaxaca,
            Variables.participacionPasada,
            Variables.aripo);
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

  Future getData(folio) async {
    response = await dio.get("https://sistema-ioa.com/api/fast_query",
        queryParameters: {"consulta": "getDataOrganizacion", "id": folio});
    final result = response.data;

    organizacion = Organizacion.fromJson(result);

    setState(() {
      nombre.text = organizacion.nombreOrganizacion;
      representante.text = organizacion.representante;
    });
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
        future: listOrganizaciones(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  body: responsive == false
                      ? ListView(
                          controller: scrol1,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  _createFicha(
                                      "CESAR MELCHOR GARCIA",
                                      "CESAR MELCHOR GARCIA",
                                      "VALLES CENTRALES",
                                      "OAXACA",
                                      "SAN ANTONIO DE LA CAL",
                                      "LOCALIDAD",
                                      "BENITO JUAREZ",
                                      "27",
                                      "71236",
                                      "ASADADASD",
                                      "9512913901",
                                      "MARCA DE DESCRIPCION",
                                      "HUESOS Y TEXTILES",
                                      "ASDADASDASDASDASDASDASDASDASD",
                                      "23",
                                      "SI",
                                      "SI",
                                      "SI",
                                      "SI",
                                      "SI");
                                },
                                child: Text("GENERAR")),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                                width: Adaptive.w(100),
                                height: Adaptive.h(10),
                                color: Variables.colorMorado,
                                child: Center(
                                    child: Text(
                                  "REGISTRO DE INFORMACIÓN POR GRUPO",
                                  style: TextStyle(
                                      fontFamily: Variables.fontPlayRegular,
                                      fontSize: Adaptive.sp(13),
                                      color: Colors.white),
                                ))),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(1.5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Adaptive.h(7),
                                      ),
                                      SizedBox(
                                          width: Adaptive.w(30),
                                          child: CustomSearchableDropDown(
                                              menuPadding: EdgeInsets.symmetric(
                                                  horizontal: Adaptive.w(15)),
                                              items: _organizaciones,
                                              label: 'ORGANIZACIONES',
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6)),
                                                  border: Border.all(
                                                      color:
                                                          Variables.colorAzul)),
                                              dropDownMenuItems:
                                                  _organizaciones.map((item) {
                                                return item.nombreOrganizacion;
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  Variables.nombreOrganizacion =
                                                      value.nombreOrganizacion;
                                                  Variables.folioGrupo =
                                                      value.idGrupo;
                                                  Variables
                                                          .representanteOrganizacion =
                                                      value.representante;
                                                  representante.text =
                                                      value.representante;
                                                  Variables.calle = value.calle;
                                                  Variables.numero =
                                                      value.numeroExterior;
                                                  Variables.cp = value.cp;
                                                  Variables.region =
                                                      value.region;
                                                  Variables.estado =
                                                      value.distrito;
                                                  Variables.municipio =
                                                      value.municipio;
                                                  Variables.localidad =
                                                      value.localidad;
                                                }
                                              })),
                                      SizedBox(
                                        height: Adaptive.h(5),
                                      ),
                                      SizedBox(
                                        width: Adaptive.w(30),
                                        child: TextFormField(
                                          inputFormatters: [
                                            CapitalLetters(),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9]"))
                                          ],
                                          controller: movil,
                                          onChanged: (value) {
                                            setState(() {
                                              Variables.movil = value;
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
                                            label: const Text("TELEFONO MOVIL"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Adaptive.h(5),
                                      ),
                                      SizedBox(
                                        width: Adaptive.w(30),
                                        child: FutureBuilder(
                                          future: listRamas(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            return snapshot.hasData
                                                ? Row(
                                                    children: [
                                                      SizedBox(
                                                          width: Adaptive.w(30),
                                                          child:
                                                              CustomSearchableDropDown(
                                                                  menuPadding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          Adaptive.w(
                                                                              15)),
                                                                  items: _ramas,
                                                                  label:
                                                                      'RAMA ARTESANAL',
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          const BorderRadius.all(Radius.circular(
                                                                              6)),
                                                                      border: Border.all(
                                                                          color: Variables
                                                                              .colorAzul)),
                                                                  dropDownMenuItems:
                                                                      _ramas.map(
                                                                          (item) {
                                                                    return item
                                                                        .nombreRama;
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value !=
                                                                        null) {
                                                                      Variables
                                                                              .gruporama1 =
                                                                          value
                                                                              .idRama;
                                                                    }
                                                                  })),
                                                    ],
                                                  )
                                                : Center(
                                                    child: Image.asset(
                                                        "assets/images/cargando.gif"),
                                                  );
                                          },
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
                                        width: Adaptive.w(36),
                                        child: TextFormField(
                                          inputFormatters: [
                                            CapitalLetters(),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9a-zA-ZñÑ ]"))
                                          ],
                                          controller: representante,
                                          onChanged: (value) {
                                            setState(() {
                                              Variables
                                                      .representanteOrganizacion =
                                                  value;
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
                                            label: const Text("REPRESENTANTE"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Adaptive.h(5),
                                      ),
                                      SizedBox(
                                        width: Adaptive.w(36),
                                        child: TextFormField(
                                          inputFormatters: [
                                            CapitalLetters(),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9a-zA-ZñÑ ]"))
                                          ],
                                          controller: grupodes3,
                                          onChanged: (value) {
                                            setState(() {
                                              Variables.grupodes1 = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Variables.colorAzul),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(Variables
                                                          .borderRadiusInput))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Variables.colorGris),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          Variables.borderRadiusInput))),
                                              floatingLabelStyle: TextStyle(color: Variables.colorAzul),
                                              label: const Text("PRODUCTOS")),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
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
                                          label: const Text("TIEMPO DE ANTIGUEDAD ELABORANDO ARTESANIAS")),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(2),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
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
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Este campo no puede estar vacío";
                                        }
                                        return null;
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
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
                                      selectedItem:
                                          Variables.certificacionOaxaca,
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
                                      selectedItem:
                                          Variables.participacionPasada,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                      "CREDENCIALES DE INTEGRANTES EN PDF : "),
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
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Variables.colorAzul)),
                                    child: const Text(
                                      "SELECCIONAR",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
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
                                    width: Adaptive.w(1.5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Center(child: Text("FOTOGRAFIAS DE PIEZAS")),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            Variables.nameFilePiezaGrupo1 =
                                                file.name;
                                            Variables.pathFilePiezaGrupo1 =
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "SELECCIONAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            Variables.nameFilePiezaGrupo2 =
                                                file.name;
                                            Variables.pathFilePiezaGrupo2 =
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "SELECCIONAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            Variables.nameFilePiezaGrupo3 =
                                                file.name;
                                            Variables.pathFilePiezaGrupo3 =
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "SELECCIONAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "SELECCIONAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "SELECCIONAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "SELECCIONAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                              height: Adaptive.h(5),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Adaptive.w(35),
                                    height: Adaptive.h(7),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          if (Variables.nombreOrganizacion !=
                                                  "" &&
                                              Variables.movil != "" &&
                                              Variables
                                                      .representanteOrganizacion !=
                                                  "" &&
                                              Variables.grupodes1 != "" &&
                                              Variables.antiguedad != "" &&
                                              Variables.marca != "" &&
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
                                              _buildAlertConfirm(context);
                                            }
                                          } else {
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "Completa todos los campos.",
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
                                        style: Variables.botonGuelaguetza,
                                        child: const Text("ENVIAR"))),
                              ],
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            )
                          ],
                        )
                      :
// elementos de celular

                      ListView(
                          controller: scrol2,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                                width: Adaptive.w(100),
                                height: Adaptive.h(10),
                                color: Variables.colorMorado,
                                child: Center(
                                    child: Text(
                                  "REGISTRO DE INFORMACIÓN POR GRUPO",
                                  style: TextStyle(
                                      fontFamily: Variables.fontPlayRegular,
                                      fontSize: Adaptive.sp(13),
                                      color: Colors.white),
                                ))),
                            Center(
                              child: Image.asset(
                                "assets/images/logo_artesanias.png",
                                height: Adaptive.h(20),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(7),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                  width: Adaptive.w(30),
                                  child: CustomSearchableDropDown(
                                      menuPadding: EdgeInsets.symmetric(
                                          horizontal: Adaptive.w(5)),
                                      items: _organizaciones,
                                      label: 'ORGANIZACIONES',
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          border: Border.all(
                                              color: Variables.colorAzul)),
                                      dropDownMenuItems:
                                          _organizaciones.map((item) {
                                        return item.nombreOrganizacion;
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          Variables.nombreOrganizacion =
                                              value.nombreOrganizacion;
                                          Variables.folioGrupo = value.idGrupo;
                                          Variables.representanteOrganizacion =
                                              value.representante;
                                          representante.text =
                                              value.representante;
                                          Variables.calle = value.calle;
                                          Variables.numero =
                                              value.numeroExterior;
                                          Variables.cp = value.cp;
                                          Variables.region = value.region;
                                          Variables.estado = value.distrito;
                                          Variables.municipio = value.municipio;
                                          Variables.localidad = value.localidad;
                                        }
                                      })),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(36),
                                child: TextFormField(
                                  inputFormatters: [
                                    CapitalLetters(),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9a-zA-ZñÑ ]"))
                                  ],
                                  controller: representante,
                                  onChanged: (value) {
                                    setState(() {
                                      Variables.representanteOrganizacion =
                                          value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Variables.colorAzul),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Variables.borderRadiusInput))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Variables.colorGris),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Variables.borderRadiusInput))),
                                    floatingLabelStyle:
                                        TextStyle(color: Variables.colorAzul),
                                    label: const Text("REPRESENTANTE"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(30),
                                child: TextFormField(
                                  maxLength: 10,
                                  inputFormatters: [
                                    CapitalLetters(),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]"))
                                  ],
                                  controller: movil,
                                  onChanged: (value) {
                                    setState(() {
                                      Variables.movil = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Variables.colorAzul),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Variables.borderRadiusInput))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Variables.colorGris),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Variables.borderRadiusInput))),
                                    floatingLabelStyle:
                                        TextStyle(color: Variables.colorAzul),
                                    label: const Text("TELEFONO MOVIL"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(80),
                                child: FutureBuilder(
                                  future: listRamas(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    return snapshot.hasData
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                  width: Adaptive.w(80),
                                                  child:
                                                      CustomSearchableDropDown(
                                                          menuPadding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      Adaptive.w(
                                                                          5)),
                                                          items: _ramas,
                                                          label:
                                                              'RAMA ARTESANAL',
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          6)),
                                                              border: Border.all(
                                                                  color: Variables
                                                                      .colorAzul)),
                                                          dropDownMenuItems:
                                                              _ramas.map((item) {
                                                            return item
                                                                .nombreRama;
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            if (value != null) {
                                                              Variables
                                                                      .gruporama1 =
                                                                  value.idRama;
                                                            }
                                                          })),
                                            ],
                                          )
                                        : Center(
                                            child: Image.asset(
                                                "assets/images/cargando.gif"),
                                          );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(36),
                                child: TextFormField(
                                  inputFormatters: [
                                    CapitalLetters(),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9a-zA-ZñÑ ]"))
                                  ],
                                  controller: grupodes1,
                                  onChanged: (value) {
                                    setState(() {
                                      Variables.grupodes1 = value;
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
                                      label: const Text("PRODUCTOS")),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(20),
                                child: TextFormField(
                                  maxLength: 2,
                                  inputFormatters: [
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
                                      label: const Text(
                                          "TIEMPO DE ANTIGUEDAD ELABORANDO ARTESANIAS")),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.w(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(20),
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
                                      floatingLabelStyle:
                                          TextStyle(color: Variables.colorAzul),
                                      label: const Text(
                                          "NOMBRE DEL TALLER O MARCA")),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(20),
                                child: FindDropdown(
                                  showSearchBox: false,
                                  items: const ["SI", "NO"],
                                  // ignore: avoid_print
                                  onChanged: (item) {
                                    setState(() {
                                      Variables.registroMarca = item.toString();
                                    });
                                  },
                                  label: "¿CUENTA CON REGISTRO DE MARCA?",
                                  selectedItem: Variables.registroMarca,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
                                width: Adaptive.w(20),
                                child: FindDropdown(
                                  showSearchBox: false,
                                  items: const ["SI", "NO"],
                                  // ignore: avoid_print
                                  onChanged: (item) {
                                    setState(() {
                                      Variables.terminalVenta = item.toString();
                                    });
                                  },
                                  label: "¿CUENTA CON TERMINAL PUNTO DE VENTA?",
                                  selectedItem: Variables.terminalVenta,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
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
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
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
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: SizedBox(
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
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                      "CREDENCIALES DE INTEGRANTES EN PDF : "),
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
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Variables.colorAzul)),
                                    child: const Text(
                                      "BUSCAR",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
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
                                    width: Adaptive.w(1.5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Center(child: Text("FOTOGRAFIAS DE PIEZAS")),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            Variables.nameFilePiezaGrupo1 =
                                                file.name;
                                            Variables.pathFilePiezaGrupo1 =
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "BUSCAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            Variables.nameFilePiezaGrupo2 =
                                                file.name;
                                            Variables.pathFilePiezaGrupo2 =
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "BUSCAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            Variables.nameFilePiezaGrupo3 =
                                                file.name;
                                            Variables.pathFilePiezaGrupo3 =
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "BUSCAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "BUSCAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "BUSCAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                    width: Adaptive.w(3),
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(20),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        initializeDefault();
                                        final result = await FilePicker.platform
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
                                            textStyleSubTitle: const TextStyle(
                                                color: Colors.white),
                                            alignment: Alignment.centerRight,
                                            duration:
                                                const Duration(seconds: 3),
                                            isCircle: true,
                                          ).show();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Variables.colorAzul)),
                                      child: const Text(
                                        "BUSCAR",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                              height: Adaptive.h(5),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: Adaptive.w(35),
                                    height: Adaptive.h(7),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          if (Variables.nombreOrganizacion !=
                                                  "" &&
                                              Variables.movil != "" &&
                                              Variables
                                                      .representanteOrganizacion !=
                                                  "" &&
                                              Variables.grupodes1 != "" &&
                                              Variables.antiguedad != "" &&
                                              Variables.marca != "" &&
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
                                              _buildAlertConfirm(context);
                                            }
                                          } else {
                                            AchievementView(
                                              context,
                                              title: "Aviso",
                                              subTitle:
                                                  "Completa todos los campos.",
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
                                        style: Variables.botonGuelaguetza,
                                        child: const Text("ENVIAR"))),
                                SizedBox(
                                  height: Adaptive.h(5),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Adaptive.h(5),
                            )
                          ],
                        ),
                )
              : Center(
                  child: Image.asset("assets/images/cargando.gif"),
                );
        });
  }

  void realizarRegistro() {
    registro(
        Variables.folioGrupo,
        Variables.nombreOrganizacion,
        Variables.representanteOrganizacion,
        Variables.rama1,
        Variables.rama2,
        Variables.rama3,
        Variables.grupodes1,
        Variables.grupodes2,
        Variables.grupodes3,
        Variables.antiguedad,
        Variables.marca,
        Variables.registroMarca,
        Variables.terminalVenta,
        Variables.certificacionOaxaca,
        Variables.participacionPasada,
        Variables.aripo,
        Variables.pathFileCredencial,
        Variables.pathFilePiezaGrupo1,
        Variables.pathFilePiezaGrupo2,
        Variables.pathFilePiezaGrupo3,
        Variables.pathFileTaller1,
        Variables.pathFileTaller2,
        Variables.pathFileTaller3);
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

                          organizacion = Organizacion(
                              idGrupo: "",
                              representante: "",
                              nombreOrganizacion: "",
                              calle: "",
                              numeroExterior: "",
                              cp: "",
                              region: "",
                              distrito: "",
                              municipio: "",
                              localidad: "");
                          Variables.movil = '';
                          Variables.rama1 = '';
                          Variables.grupodes1 = '';
                          Variables.antiguedad = '';
                          Variables.marca = '';
                          Variables.registroMarca = '';
                          Variables.terminalVenta = '';
                          Variables.certificacionOaxaca = '';
                          Variables.participacionPasada = '';
                          Variables.aripo = '';
                          Variables.pathFileCredencial = '';
                          Variables.pathFileCarta = '';
                          Variables.pathFilePiezaGrupo1 = '';
                          Variables.pathFilePiezaGrupo2 = '';
                          Variables.pathFilePiezaGrupo3 = '';
                          Variables.pathFileTallerGrupo1 = '';
                          Variables.pathFileTallerGrupo2 = '';
                          Variables.pathFileTallerGrupo3 = '';
                          Variables.foto1 = false;
                          Variables.foto2 = false;
                          Variables.foto3 = false;
                          Variables.foto4 = false;
                          Variables.foto5 = false;
                          Variables.foto6 = false;
                          Variables.archivo1 = false;
                          Variables.archivo2 = false;
                          Variables.avisoPrivacidad = false;
                          Variables.nombreOrganizacion = "";
                          Variables.folioGrupo = "";
                          Variables.representanteOrganizacion = "";
                          Variables.calle = "";
                          Variables.numero = "";
                          Variables.cp = "";
                          Variables.region = "";
                          Variables.estado = "";
                          Variables.municipio = "";
                          Variables.localidad = "";
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
                        _createPDF(response.data, Variables.nombreOrganizacion);
                        _createFicha(
                            Variables.nombreOrganizacion,
                            Variables.representanteOrganizacion,
                            Variables.region,
                            Variables.estado,
                            Variables.municipio,
                            Variables.localidad,
                            Variables.calle,
                            Variables.numero,
                            Variables.cp,
                            Variables.folioGrupo,
                            Variables.movil,
                            Variables.marca,
                            Variables.rama1,
                            Variables.grupodes1,
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
            title: const Text("CARGANDO..."),
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(10)),
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

  _buildAlertConfirm(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("CONFIRMACIÓN DE INSCRIPCIÓN"),
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(10)),
            content: Text(
              "Una vez que registre el grupo, los integrantes no podrán realizar registros individuales.",
              style:
                  TextStyle(fontFamily: Variables.fontPlayItalic, fontSize: 18),
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    realizarRegistro();
                    apps();
                  },
                  child: Text(
                    "Aceptar",
                    style: TextStyle(
                        fontFamily: Variables.fontPlayItalic, fontSize: 18),
                  )),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                        fontFamily: Variables.fontPlayItalic, fontSize: 18),
                  )),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
        barrierColor: Colors.white70,
        barrierDismissible: false);
  }
}

Future<void> _createPDF(folio, nombre) async {
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
      nombre,
      brush: PdfBrushes.purple,
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(282, 188, 0, 0));

  List<int> bytes = await document.save();
  document.dispose();
  saveAndLaunchFile(bytes, "Folio_$folio.pdf");
}

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load(name);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<void> _createFicha(
    nombre,
    representante,
    region,
    estado,
    municipio,
    localidad,
    calle,
    numero,
    cp,
    folio,
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

  grid2.columns.add(count: 2);
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

  row2.cells[0].value = 'NOMBRE';
  row2.cells[1].value = 'REPRESENTANTE';

  PdfGridRow row3 = grid2.rows.add();

  row3.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row3.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row3.cells[0].value = nombre;
  row3.cells[1].value = representante;

  grid2.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 95, page.getClientSize().width, page.getClientSize().height));

  grid3.columns.add(count: 3);
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

  row4.cells[0].value = 'DISTRITO';
  row4.cells[1].value = 'MUNICIPIO';
  row4.cells[2].value = 'LOCALIDAD';

  PdfGridRow row5 = grid3.rows.add();

  grid3.style.cellPadding = PdfPaddings(top: 5);
  row5.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row5.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row5.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row5.cells[2].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row5.cells[0].value = estado;
  row5.cells[1].value = municipio;
  row5.cells[2].value = localidad;

  grid3.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 135, page.getClientSize().width, page.getClientSize().height));

  grid4.columns.add(count: 1);
  PdfGridRow row6 = grid4.rows.add();
  grid4.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 11));
  row6.cells[0].style.stringFormat =
      PdfStringFormat(alignment: PdfTextAlignment.center, wordSpacing: 5);

  row6.cells[0].value = 'DOMICILIO';
  grid4.style.cellPadding = PdfPaddings(left: 5, top: 5);

  PdfGridRow row7 = grid4.rows.add();

  grid4.style.cellPadding = PdfPaddings(top: 5);
  row7.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row7.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row7.cells[0].value = "$calle, $numero, $cp";

  grid4.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 217, page.getClientSize().width, page.getClientSize().height));

  grid5.columns.add(count: 2);
  PdfGridRow row8 = grid5.rows.add();

  grid5.style.cellPadding = PdfPaddings(top: 5);
  row8.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row8.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row8.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row8.cells[0].value = 'FOLIO DE GRUPO';
  row8.cells[1].value = 'CELULAR';

  PdfGridRow row9 = grid5.rows.add();

  row9.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row9.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row9.cells[0].value = folio;
  row9.cells[1].value = celular;

  grid5.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 177, page.getClientSize().width, page.getClientSize().height));

  grid6.columns.add(count: 1);
  PdfGridRow row10 = grid6.rows.add();
  grid6.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.dimGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 11));
  row10.cells[0].style.stringFormat =
      PdfStringFormat(alignment: PdfTextAlignment.center, wordSpacing: 5);

  row10.cells[0].value = 'REGISTRO';
  grid6.style.cellPadding = PdfPaddings(left: 5, top: 5);

  grid6.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 304, page.getClientSize().width, page.getClientSize().height));

  grid7.columns.add(count: 2);
  PdfGridRow row11 = grid7.rows.add();

  grid7.style.cellPadding = PdfPaddings(top: 5);
  row11.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row11.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row11.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row11.cells[0].value = 'FOLIO DE REGISTRO';
  row11.cells[1].value = 'NOMBRE DE TALLER O MARCA';

  PdfGridRow row12 = grid7.rows.add();

  grid7.style.cellPadding = PdfPaddings(top: 5);
  row12.style =
      PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

  row12.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );
  row12.cells[1].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  row12.cells[0].value = folio;
  row12.cells[1].value = marca;

  grid7.draw(
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
