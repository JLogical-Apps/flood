import 'id_generator.dart';

/// Generates ids by mapping an object to its id.
class MapperIdGenerator<T, R> extends IdGenerator<T, R> {
  /// Maps the [object] to its id.
  final R Function(T object) mapper;

  MapperIdGenerator(this.mapper);

  @override
  R getId(T? object) {
    if (object == null) {
      throw Exception('Cannot create a mapped id when the object is null!');
    }

    return mapper(object);
  }
}
