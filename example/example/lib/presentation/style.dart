import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

const bool isLight = false;

FlatStyle style = FlatStyle(
  primaryColor: Color(0xff3394ed),
  backgroundColor: Color(0xff09090b),
);

Color getCentsColor(int? amountCents) {
  if (amountCents == null || amountCents == 0) {
    return Colors.white;
  }
  if (amountCents > 0) {
    return Colors.green;
  }
  return Colors.red;
}
