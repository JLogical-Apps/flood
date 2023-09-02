# ValueStream

[rxdart](https://pub.dev/packages/rxdart) provides many utilities for handling Streams, but one thing was lacking. There are many cases where you want to create a Stream and also know what its value is synchronously. `rxdart` provides this functionality with `ValueStream` and `BehaviorSubject`, but transforming a `ValueStream` always results in an asynchronous Stream instead of another `ValueStream`. So, this directory contains many utilities to help transform `ValueStream`s into other `ValueStream`s so you can retrieve the value of them synchronously.

Here are some of those utilities:

- `valueStream.mapWithValue(mapper)`: Just like `.map()`, except you can retrieve the current value synchronously.
- `valueStream.switchMapWithValue(mapper)`: Just like `.switchMap()`, except you can retrieve the current value synchronously.
- `valueStream.asyncMapWithValue(mapper)`: Just like `.asyncMap()`, except you can retrieve the latest value emitted. The async mapper _only_ works when listened to!
- `valueStream.waitUntil(predicate)`: A Future that listens to the stream until the predicate is true.
- `[valueStream1, valueStream2].combineLatestWithValue(mapper)`: Just like `.combineLatest()`, except you can retrieve the current value synchronously.
- `myFuture.asValueStream()`: Converts a Future into a `ValueStream`, which will emit `FutureValue`s of its current state until it completes.
