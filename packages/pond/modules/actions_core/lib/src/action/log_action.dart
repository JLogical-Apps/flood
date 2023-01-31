import 'package:actions_core/actions_core.dart';

class LogAction<P, R> with IsActionWrapper<P, R> {
  final Action<P, R> source;

  LogAction({required this.source});

  @override
  late final Action<P, R> action = source.withAdditionalSetup(
    onCall: (parameters) => print('Calling [${source.name}] with [$parameters]'),
    onCalled: (parameters, result) => print('Called [${source.name}] with [$parameters]: $result'),
    onFailed: (parameters, error, stackTrace) =>
        print('ERROR: Called [${source.name}] with [$parameters]: $error\n$stackTrace'),
  );
}
