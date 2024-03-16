# FutureValue

This utility provides a `FutureValue` class. To give credit where credit is due, this is heavily inspired by Remi Rousselet's `freezed` package which has a class with the same name. Instead of depending on that entire package, I rewrote most of the functionality here to be used throughout Flood.

A FutureValue holds 1 of 4 states, `empty`, `loading`, `loaded`, and `error`. You can use `FutureValue`s when listening the state of an asynchronous function. For example, this is used heavily in the [Model](../../../../../model/model_core/README.md) package to store information about the state of a Model.

You can see the state of a `FutureValue` by calling one of these methods:

- `myFutureValue.isEmpty`
- `myFutureValue.isLoading`
- `myFutureValue.isLoaded`
- `myFutureValue.isError`

If you want to get the value of a `FutureValue`, you can call `myFutureValue.get()`. This will throw an Exception if the `FutureValue` is still loading or in the error state, so you can use `myFutureValue.getOrNull()` instead if you want `null` to be returned if it's not loaded.

If you want to transform the data of a `FutureValue` depending on its state, you can use `myFutureValue.map()` to return another FutureValue which maps the loaded state of the first. For example:

```dart
final sourceFutureValue = getRandomIntFutureValue();
final mappedFutureValue = sourceFutureValue.map((randomInt) => randomInt.toString());
```

So, if `sourceFutureValue` is loaded with the value 3, `mappedFutureValue.get()` will return `"3"`. If `sourceFutureValue` is empty, loading, or has an error, `mappedFutureValue` will contain the same state.
