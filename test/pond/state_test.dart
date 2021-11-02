import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'entities/color.dart';
import 'entities/envelope.dart';
import 'entities/lucky_numbers.dart';

void main() {
  test('state inflation on simple entity.', () {
    AppContext.global = AppContext(
      entityRegistrations: [
        EntityRegistration<Envelope>(() => Envelope()),
      ],
    );

    final state = State(
      id: 'id0',
      values: {
        'name': 'Tithe',
        'amount': 24 * 100,
      },
    );

    final envelope = Entity.fromState<Envelope>(state)!;

    expect(envelope.state, state);
    expect(envelope.nameProperty.value, 'Tithe');
    expect(envelope.amountProperty.value, 24 * 100);
  });

  test('state inflation of state that has a list', () {
    AppContext.global = AppContext(
      entityRegistrations: [
        EntityRegistration<LuckyNumbers>(() => LuckyNumbers()),
      ],
    );

    const luckyNumbers = [4, 8, 15, 16, 23, 42];

    final state = State(
      id: 'id0',
      values: {
        'luckyNumbers': luckyNumbers,
      },
    );

    final luckyNumbersEntity = Entity.fromState<LuckyNumbers>(state)!;

    expect(luckyNumbersEntity.state, state);
    expect(luckyNumbersEntity.luckyNumbersProperty.value, luckyNumbers);
  });

  test('state inflation of value object that has a map.', () {
    AppContext.global = AppContext(
      valueObjectRegistrations: [
        ValueObjectRegistration<Color>(() => Color()),
      ],
    );

    const rgb = {'r': 0, 'g': 152, 'b': 19};

    final state = State(
      values: {
        'rgb': rgb,
      },
    );

    final colorValueObject = ValueObject.fromState<Color>(state)!;

    expect(colorValueObject.state, state);
    expect(colorValueObject.rgbProperty.value, rgb);
  });

  test('state inflation of entity that has a reference to a value object.', () {

  });
}
