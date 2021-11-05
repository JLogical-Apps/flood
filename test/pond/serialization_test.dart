import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';

import 'entities/color.dart';

void main() {
  test('only nullabe serializers deserialize non-null values', () {
    final stringSerializer = StringTypeStateSerializer();
    expect(() => stringSerializer.onDeserialize(null), throwsA(isA<Error>()));

    final nullableSerializer = NullableTypeStateSerializer(stringSerializer);
    expect(nullableSerializer.onDeserialize(null), null);
  });

  test('serializing strings', () {
    final stringSerializer = StringTypeStateSerializer();
    expect(stringSerializer.onDeserialize('hello world'), 'hello world');
    expect(stringSerializer.onDeserialize(5), '5');
    expect(stringSerializer.onDeserialize(3.0), '3');
    expect(stringSerializer.onDeserialize(3.16), '3.16');
    expect(stringSerializer.onDeserialize(true), 'true');
  });

  test('serializing ints', () {
    final roundingIntSerializer = IntTypeStateSerializer(intConverterPolicy: IntConverterPolicy.round());
    expect(roundingIntSerializer.onDeserialize(5), 5);
    expect(roundingIntSerializer.onDeserialize(3.5), 4);
    expect(roundingIntSerializer.onDeserialize(1.2), 1);
    expect(roundingIntSerializer.onDeserialize(4.9), 5);
    expect(roundingIntSerializer.onDeserialize('-2.5'), -3);
    expect(roundingIntSerializer.onDeserialize('-10'), -10);
    expect(() => roundingIntSerializer.onDeserialize('hello world'), throwsA(isA<FormatException>()));

    final flooringIntSerializer = IntTypeStateSerializer(intConverterPolicy: IntConverterPolicy.floor());
    expect(flooringIntSerializer.onDeserialize(5), 5);
    expect(flooringIntSerializer.onDeserialize(3.5), 3);
    expect(flooringIntSerializer.onDeserialize(1.2), 1);
    expect(flooringIntSerializer.onDeserialize(4.9), 4);
    expect(flooringIntSerializer.onDeserialize('-2.5'), -3);
    expect(flooringIntSerializer.onDeserialize('-10'), -10);

    final truncatingIntSerializer = IntTypeStateSerializer(intConverterPolicy: IntConverterPolicy.truncate());
    expect(truncatingIntSerializer.onDeserialize(5), 5);
    expect(truncatingIntSerializer.onDeserialize(3.5), 3);
    expect(truncatingIntSerializer.onDeserialize(1.2), 1);
    expect(truncatingIntSerializer.onDeserialize(4.9), 4);
    expect(truncatingIntSerializer.onDeserialize('-2.5'), -2);
    expect(truncatingIntSerializer.onDeserialize('-10'), -10);
  });

  test('serializing doubles', () {
    final doubleSerializer = DoubleTypeStateSerializer();
    expect(doubleSerializer.onDeserialize(5), 5.0);
    expect(doubleSerializer.onDeserialize(3.5), 3.5);
    expect(doubleSerializer.onDeserialize('-2.5'), -2.5);
    expect(doubleSerializer.onDeserialize('-10'), -10.0);
    expect(() => doubleSerializer.onDeserialize('hello world'), throwsA(isA<FormatException>()));
  });

  test('serializing bools', () {
    final boolSerializer = BoolTypeStateSerializer();
    expect(boolSerializer.onDeserialize(false), false);
    expect(boolSerializer.onDeserialize('true'), true);
  });

  test('serializing value objects', () {
    AppContext.global = AppContext(valueObjectRegistrations: [
      ValueObjectRegistration<Color, Color?>(() => Color()),
    ]);

    final white = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};
    final colorSerializer = ValueObjectTypeStateSerializer<Color>();

    expect(colorSerializer.onSerialize(white), {
      'rgb': {'r': 255, 'g': 255, 'b': 255}
    });

    expect(
      colorSerializer.onDeserialize({
        'rgb': {'r': 255, 'g': 255, 'b': 255}
      }),
      white,
    );

    expect(() => colorSerializer.onDeserialize(null), throwsA(isA<Error>()));

    final nullableColorSerializer = NullableTypeStateSerializer(colorSerializer);
    expect(nullableColorSerializer.onDeserialize(null), null);
  });

  test('serializing lists', () {
    AppContext.global = AppContext(valueObjectRegistrations: [
      ValueObjectRegistration<Color, Color?>(() => Color()),
    ]);

    final nonNullListSerializer = ListTypeStateSerializer<int>();
    expect(nonNullListSerializer.onDeserialize(['2', 4]), [2, 4]);
    expect(nonNullListSerializer.onDeserialize([]), []);
    expect(() => nonNullListSerializer.onDeserialize(['hello world']), throwsA(isA<FormatException>()));
    expect(() => nonNullListSerializer.onDeserialize([null, 4]), throwsA(isA<Error>()));

    final nullableListSerializer = ListTypeStateSerializer<int?>();
    expect(nullableListSerializer.onDeserialize([null, 4]), [null, 4]);

    final white = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};
    final black = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};
    final colorSerializer = ListTypeStateSerializer<Color>();
    expect(
      colorSerializer.onDeserialize([
        {
          'rgb': {'r': 255, 'g': 255, 'b': 255}
        },
        {
          'rgb': {'r': 0, 'g': 0, 'b': 0}
        },
      ]),
      [white, black],
    );

    expect(() => colorSerializer.onDeserialize([null]), throwsA(isA<Error>()));

    final nullableColorSerializer = ListTypeStateSerializer<Color?>();
    expect(nullableColorSerializer.onDeserialize([null]), [null]);
  });

  test('serializing maps', () {
    final nonNullListSerializer = MapTypeStateSerializer<int, String>();
    expect(nonNullListSerializer.onDeserialize({1: 'one', '2': 'two'}), {1: 'one', 2: 'two'});
    expect(nonNullListSerializer.onDeserialize({}), {});
    expect(() => nonNullListSerializer.onDeserialize(['hello world']), throwsA(isA<Exception>()));
    expect(() => nonNullListSerializer.onDeserialize({'hello world': 1}), throwsA(isA<FormatException>()));
    expect(() => nonNullListSerializer.onDeserialize({0: null}), throwsA(isA<Error>()));

    final nullableListSerializer = MapTypeStateSerializer<int, String?>();
    expect(nullableListSerializer.onDeserialize({0: null}), {0: null});

    final white = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};
    final black = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};
    final colorSerializer = ListTypeStateSerializer<Color>();
    expect(
      colorSerializer.onDeserialize([
        {
          'rgb': {'r': 255, 'g': 255, 'b': 255}
        },
        {
          'rgb': {'r': 0, 'g': 0, 'b': 0}
        },
      ]),
      [white, black],
    );
  });
}
