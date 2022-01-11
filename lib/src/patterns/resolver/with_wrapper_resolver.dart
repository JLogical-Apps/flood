import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:collection/collection.dart';

mixin WithWrapperResolver<In, OutWrapper extends Wrapper<In>> implements Resolver<In, OutWrapper> {
  List<OutWrapper> get wrappers;

  @override
  OutWrapper? resolveOrNull(In input) {
    return wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(input));
  }
}
