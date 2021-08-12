import 'package:rxdart/rxdart.dart';

/// Creates a stream that never changes.
ValueStream<T> constantStream<T>(T value) => BehaviorSubject.seeded(value);
