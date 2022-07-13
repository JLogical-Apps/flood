abstract class TypeStateSerializer<T> {
  dynamic serialize(T value);

  T deserialize(dynamic value);

  bool matchesType(Type type) {
    return T == type;
  }

  bool matchesSerializing(dynamic value) {
    return value is T;
  }

  bool matchesDeserializing(dynamic value) {
    return value is T;
  }
}
