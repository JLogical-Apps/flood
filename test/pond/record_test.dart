import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';

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
}
