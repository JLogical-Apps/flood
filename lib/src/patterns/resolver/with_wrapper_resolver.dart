import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';

mixin WithWrapperResolver<In, OutWrapper extends Wrapper<In>> implements Resolver<In, OutWrapper> {
  List<OutWrapper> get wrappers;

  @override
  OutWrapper resolve<V extends In>(V input) {
    return wrappers.firstWhere((wrapper) => wrapper.shouldWrap(input));
  }
}
