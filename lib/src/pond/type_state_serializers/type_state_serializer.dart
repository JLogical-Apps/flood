abstract class TypeStateSerializer<T> {
  dynamic onSerialize(T value);

  T? onDeserialize(dynamic value);

  Type get type => T;
}
