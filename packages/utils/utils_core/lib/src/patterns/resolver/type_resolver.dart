import 'package:collection/collection.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';

class TypeResolver<O> implements Resolver<Type, O> {
  final List<O> objects;

  const TypeResolver({required this.objects});

  @override
  O? resolveOrNull(Type input) {
    return objects.firstWhereOrNull((object) => object.runtimeType == input);
  }
}
