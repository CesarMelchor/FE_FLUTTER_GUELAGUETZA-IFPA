import 'package:flutter/material.dart';
import 'package:guelaguetza/src/screens/grupo.dart';
import 'package:guelaguetza/src/screens/home.dart';
import 'package:guelaguetza/src/screens/indivivual.dart';
import 'package:guelaguetza/src/screens/sorteo.dart';
import 'package:vrouter/vrouter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(
    ResponsiveSizer(
      builder: (context, orientation, screenType) {
    return VRouter(
      initialUrl: '/sorteo',
      title: 'IOA',
      debugShowCheckedModeBanner: false,
      routes: [
        VWidget(path: '/home', widget: const MyHomePage()),
        VWidget(path: '/individual', widget: const IndividualRegisterScreen()),
        VWidget(path: '/grupo', widget: const GrupoRegisterScreen()),
        VWidget(path: '/sorteo', widget: const SorteoScreen()),
      ],
    );
  }));
}
