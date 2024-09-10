import 'package:flutter/material.dart';
import 'dart:math' as math;

class Sizzing {
  double _width = 0, _height = 0, _diagonal = 0, _decima = 0, _novena = 0, _octava = 0, _septima = 0
  ,_sexta = 0, _quinta = 0, _cuarta = 0, _tercia = 0, _mitad = 0, _anchoResta = 0;


  double get width => _width;
  double get height => _height;
  double get decima => _decima;
  double get novena => _novena;
  double get octava => _octava;
  double get septima => _septima;
  double get sexta => _sexta;
  double get quinta => _quinta;
  double get cuarta => _cuarta;
  double get tercia => _tercia;
  double get mitad => _mitad;
  double get anchoResta => _anchoResta;
  double get diagonal => _diagonal;

  static Sizzing of(BuildContext context) => Sizzing(context);

  Sizzing(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _decima = size.height / 10;
    _novena = size.height / 9;
    _octava = size.height / 8;
    _septima = size.height / 7;
    _sexta = size.height / 6;
    _quinta = size.height / 5;
    _cuarta = size.height / 4;
    _tercia = size.height / 3;
    _mitad = size.height / 2;
    _anchoResta = (_decima * 2) - size.height ;


    _diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
  }
}
