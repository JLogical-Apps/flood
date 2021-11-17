import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';

mixin WithSubtypeWrapper<S extends T, T> implements Wrapper<T> {
  @override
  bool shouldWrap(T value) => value is S;
}