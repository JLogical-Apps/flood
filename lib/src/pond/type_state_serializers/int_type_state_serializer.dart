import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class IntTypeStateSerializer extends TypeStateSerializer<int> {
  final IntConverterPolicy intConverterPolicy;

  IntTypeStateSerializer({this.intConverterPolicy: const _RoundingConverterPolicy()});

  @override
  int deserialize(value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    if (value is int) {
      return value;
    }

    num number;
    if (value is num) {
      number = value;
    } else {
      number = num.parse(value.toString());
    }

    return intConverterPolicy.convert(number);
  }

  @override
  serialize(int value) {
    return value;
  }
}

abstract class IntConverterPolicy {
  const IntConverterPolicy();

  int convert(num value);

  static IntConverterPolicy round() {
    return _RoundingConverterPolicy();
  }

  static IntConverterPolicy floor() {
    return _FlooringConverterPolicy();
  }

  static IntConverterPolicy truncate() {
    return _TruncatingConverterPolicy();
  }
}

class _RoundingConverterPolicy extends IntConverterPolicy {
  const _RoundingConverterPolicy();

  @override
  int convert(num value) => value.round();
}

class _FlooringConverterPolicy extends IntConverterPolicy {
  const _FlooringConverterPolicy();

  @override
  int convert(num value) => value.floor();
}

class _TruncatingConverterPolicy extends IntConverterPolicy {
  const _TruncatingConverterPolicy();

  @override
  int convert(num value) => value.truncate();
}
