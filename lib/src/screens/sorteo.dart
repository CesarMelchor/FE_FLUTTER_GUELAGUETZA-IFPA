import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guelaguetza/src/models/beneficiario.dart';
import 'package:guelaguetza/src/utils/variables.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

class SorteoScreen extends StatefulWidget {
  const SorteoScreen({super.key});

  @override
  State<SorteoScreen> createState() => _SorteoScreenState();
}

class _SorteoScreenState extends State<SorteoScreen> {
  late Response response;
  var dio = Dio();
  bool sorteo = false;

  List<Beneficiario> _beneficiarios = [];



  Future folios() async {
    _buildAlertDialogLoading(context);
    response = await dio.get("https://sorteo.sistema-ioa.com/api/sorteo.php");
    final result = response.data;
    Iterable list = result;
    _beneficiarios =
        list.map<Beneficiario>((json) => Beneficiario.fromJson(json)).toList();
    setState(() {
      sorteo = true;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    return _beneficiarios;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
                      SizedBox(
                          height: Adaptive.h(100),
                          child: Image.asset(
                            "assets/images/imagen_home.png",
                          )),
        SizedBox(
          width: Adaptive.w(65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_artesanias.png",
                height: Adaptive.w(20),
              ),
              sorteo == true
                  ? SizedBox(
                      height: Adaptive.h(52),
                      width: Adaptive.w(50),
                      child: ScrollLoopAutoScroll(
                        scrollDirection: Axis.vertical, //required
                        delay: Duration(seconds: 2),
                        duration: Duration(seconds: 4000),
                        gap: 650,
                        reverseScroll: false,
                        duplicateChild: 25,
                        enableScrollInput: true,
                        delayAfterScrollInput: Duration(seconds: 1),
                        child: Column(
                          children: [
                            ..._beneficiarios.map(buildSingleTextHorizontal).toList()
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
                  sorteo == false ?
              SizedBox(
                height: Adaptive.h(10),
                width: Adaptive.w(20),
                child: OutlinedButton(
                    style: Variables.raisedButtonStyle2,
                    onPressed: () {
                      folios();
                    },
                    child: Text(
                      "COMENZAR SORTEO",
                      style: TextStyle(fontFamily: Variables.fontPlayRegular),
                    )),
              ) : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSingleTextHorizontal(Beneficiario beneficiarios) =>
      buildTextHorizontal(beneficiarios: beneficiarios);

  Widget buildTextHorizontal({required Beneficiario beneficiarios}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${beneficiarios.id} : ${beneficiarios.nombre} ${beneficiarios.paterno} ${beneficiarios.materno}",
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: Adaptive.sp(14),
                color: Colors.black),
          ),
          const Divider(
            thickness: 2,
          )
        ],
      );

  _buildAlertDialogLoading(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(10), vertical: Adaptive.h(5)),
            content: Image.asset(
              "assets/images/cargando.gif",
              width: Adaptive.w(80),
              height: Adaptive.h(90),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
        barrierColor: Colors.white70,
        barrierDismissible: false);
  }
}
