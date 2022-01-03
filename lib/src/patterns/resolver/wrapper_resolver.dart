import 'package:jlogical_utils/src/patterns/resolver/with_wrapper_resolver.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';

import 'resolver.dart';

class WrapperResolver<In, OutWrapper extends Wrapper<In>>
    with WithWrapperResolver<In, OutWrapper>
    implements Resolver<In, OutWrapper> {
  @override
  final List<OutWrapper> wrappers;

  const WrapperResolver(this.wrappers);
}
