import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'entities/color.dart';
import 'entities/envelope.dart';
import 'entities/lucky_numbers.dart';
import 'entities/user_avatar.dart';

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

  test('state inflation of record that has a list', () {
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

  test('state inflation of record that has a map.', () {
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

    final color = ValueObject.fromState<Color>(state)!;

    expect(color.state, state);
    expect(color.rgbProperty.value, rgb);
  });

  test('state inflation of record that has a reference to a value object.', () {
    AppContext.global = AppContext(
      valueObjectRegistrations: [
        ValueObjectRegistration<Color>(() => Color()),
        ValueObjectRegistration<UserAvatar>(() => UserAvatar()),
      ],
    );

    const rgb = {'r': 0, 'g': 152, 'b': 19};

    final state = State(
      values: {
        'color': {
          'rgb': rgb,
        },
      },
    );

    final userAvatar = ValueObject.fromState<UserAvatar>(state)!;
    final color = Color()..rgbProperty.value = rgb;

    expect(userAvatar.state, state);
    expect(userAvatar.colorProperty.value, color);
  });
}
