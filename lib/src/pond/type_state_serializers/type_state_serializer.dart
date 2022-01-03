abstract class TypeStateSerializer<T> {
  dynamic serialize(T value);

  T deserialize(dynamic value);

  Type get type => T;
}
