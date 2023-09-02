import 'package:actions_core/actions_core.dart';
import 'package:log_core/log_core.dart';
import 'package:pond_core/pond_core.dart';

class LogAction<P, R> with IsActionWrapper<P, R> {
  final CorePondContext context;
  final Action<P, R> source;

  LogAction({required this.context, required this.source});

  @override
  late final Action<P, R> action = source.withAdditionalSetup(
    onCall: (parameters) => context.log('Calling [${source.name}] with [$parameters]'),
    onCalled: (parameters, result) => context.log('Called [${source.name}] with [$parameters]: $result'),
    onFailed: (parameters, error, stackTrace) => context.logError(error, stackTrace),
  );
}
