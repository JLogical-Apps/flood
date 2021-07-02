import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

/// Helper for using a value stream.
T useValueStream<T>(ValueStream<T> stream) {
  useStream(stream);
  return stream.value;
}

/// Performs an action only once in a HookWidget. Similar to [initState] of a StatefulWidget.
void useOneTimeEffect(void Function()? Function() effect) {
  useEffect(effect, [0]);
}
