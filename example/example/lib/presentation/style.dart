import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

const bool isLight = false;

FlatStyle style = FlatStyle(
  primaryColor: Color(0xff4dac55),
  backgroundColor: isLight ? Color(0xffeeeeee) : Color(0xff141424),
);

Color getCentsColor(int amountCents) {
  if (amountCents == 0) {
    return Colors.white;
  }
  if (amountCents > 0) {
    return Colors.green;
  }
  return Colors.red;
}
