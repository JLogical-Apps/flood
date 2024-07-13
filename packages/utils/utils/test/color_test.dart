import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:utils/utils.dart';

void main() {
  test('color to hex', () {
    expect(Colors.red.toHex(), '#fff44336');
  });
}
