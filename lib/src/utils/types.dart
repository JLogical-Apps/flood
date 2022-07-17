/// Returns whether [A] is a subtype of [B].
bool isSubtype<A, B>() => <A>[] is List<B>;

Type getRuntimeType<T>() {
  return T;
}

extension TypeExtensions on Type {
  bool isNullable() {
    return toString().endsWith('?');
  }
}
