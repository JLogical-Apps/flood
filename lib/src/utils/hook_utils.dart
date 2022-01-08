import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

import '../../jlogical_utils.dart';

/// Helper for using a value stream.
T useValueStream<T>(ValueStream<T> stream) {
  useStream(stream);
  return stream.value;
}

/// Helper for using a value stream. Returns a null value if the stream is null.
T? useValueStreamOrNull<T>(ValueStream<T>? stream) {
  useStream(stream);
  return stream?.value;
}

/// Performs an action only once in a HookWidget. Similar to [initState] of a StatefulWidget.
void useOneTimeEffect(void Function()? Function() effect) {
  useEffect(effect, [0]);
}

/// Listens to a future but memoizes the future to prevent rebuilds every frame.
AsyncSnapshot<T> useMemoizedFuture<T>(
  Future<T> futureGetter(), [
  List<Object?> keys = const <Object>[],
]) {
  return useFuture(useMemoized(futureGetter, keys));
}

/// Creates a BehaviorSubject with the value from [create] and is automatically disposed when the widget is disposed.
/// If [shouldListen], then will also listen to the BehaviorSubject. If [shouldListen] is changed between builds, it will cause errors.
BehaviorSubject<T> useObservable<T>(T create(), {bool shouldListen: true}) {
  var subject = useMemoized(() => BehaviorSubject.seeded(create()));
  useOneTimeEffect(() => subject.close);
  if (shouldListen) useValueStream(subject);
  return subject;
}

/// Creates and listens to a ValueStream from [create] and is automatically disposed when the widget is disposed.
ValueStream<C> useComputed<V, C>(ValueStream<C> create()) {
  var stream = useMemoized(create);
  useValueStream(stream);
  return stream;
}

/// Listens to an async loadable.
M? useModelOrNull<M extends AsyncLoadable<V>, V>(M? model) {
  model?.ensureLoadingStarted();
  useValueStreamOrNull(model?.valueX);
  return model;
}

M useModel<M extends AsyncLoadable<V>, V>(M model) {
  return useModelOrNull(model)!;
}

/// Listens to a stream and disposes of the listener when the widget is disposed.
void useListen<V>(Stream<V> stream, void onValueChanged(V value)) {
  useOneTimeEffect(() {
    var subscription = stream.listen(onValueChanged);
    return subscription.cancel;
  });
}
