import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

const bool isLight = false;

Style style = FlatStyle(
  primaryColor: Color(0xff4dac55),
  backgroundColor: isLight ? Color(0xffeeeeee) : Color(0xff141424),
  minPrimaryColorDistance: 20000,
);
