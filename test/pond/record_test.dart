import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/record/immutability_violation_error.dart';

import 'entities/color.dart';
import 'entities/envelope.dart';

void main() {
  test('simple entity has proper state.', () {
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

  test('equality of ValueObjects is their state.', () {
    final white = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};

    final white2 = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};

    final black = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};

    expect(white, equals(white2));
    expect(white, isNot(equals(black)));
  });

  test('equality of Entities is their id.', () {
    final originalEnvelope = Envelope()
      ..id = 'envelope'
      ..nameProperty.value = 'A'
      ..amountProperty.value = 204 * 100;

    final envelopeWithSameIdDifferentContent = Envelope()
      ..id = 'envelope'
      ..nameProperty.value = 'B'
      ..amountProperty.value = 24 * 100;

    final envelopeWithDifferentIdSameContent = Envelope()
      ..id = 'something_different'
      ..nameProperty.value = 'A'
      ..amountProperty.value = 204 * 100;

    expect(originalEnvelope, equals(envelopeWithSameIdDifferentContent));
    expect(originalEnvelope, isNot(equals(envelopeWithDifferentIdSameContent)));
  });

  test('can change properties of Entity after validation.', () {
    final envelope = Envelope()
      ..nameProperty.value = 'Tithe'
      ..amountProperty.value = 25 * 100
      ..validate();

    expect(() => envelope.amountProperty.value = 10 * 100, returnsNormally);
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
