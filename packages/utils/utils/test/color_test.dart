import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:utils/utils.dart';

void main() {
  test('color to hex', () {
    expect(Colors.red.toHex(), '#fff44336');
    expect(Colors.red.toHex(includeAlpha: false), '#f44336');
    expect(Colors.red.toHex(leadingHashSign: false), 'fff44336');
    expect(Colors.red.toHex(leadingHashSign: false, includeAlpha: false), 'f44336');
  });
}
