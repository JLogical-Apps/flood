import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/record/value_object_immutable_violation_error.dart';

import 'entities/color.dart';
import 'entities/envelope.dart';

void main() {
  test('simple entity has proper state', () {
    final envelope = Envelope()
      ..nameProperty.value = 'Tithe'
      ..amountProperty.value = 24 * 100;

    expect(
      envelope.state,
      State(
        values: {
          'name': 'Tithe',
          'amount': 24 * 100,
        },
      ),
    );
  });

  test('cannot change properties of ValueObjects once validated.', () {
    final color = Color()
      ..rgbProperty.value = {
        'r': 255,
        'g': 255,
        'b': 255,
      }
      ..validate();

    expect(
      () => color.rgbProperty.value = {'r': 0, 'g': 0, 'b': 0},
      throwsA(isA<ImmutabilityViolationError>()),
    );
  });
}
