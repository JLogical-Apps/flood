import 'package:utils_core/src/patterns/resolver/resolver.dart';

class MapResolver<I, O> implements Resolver<I, O> {
  final Map<I, O> outputByInput;

  const MapResolver({required this.outputByInput});

  @override
  O? resolveOrNull(I input) {
    return outputByInput[input];
  }
}
