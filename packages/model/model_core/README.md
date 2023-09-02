# Model (Core)

This package exports Models along with utilities to help use models.

## What is a Model?

A Model is a stream of states that can be "loaded". For example, you can have a Model which loads some data from an api. When you create it, it will start in its empty state.

```dart
final model = Model(loader: () => getApiData(...));
model.state.isEmpty; // true
model.getOrNull(); // null
```

You can subscribe to its state stream to see how its state changes over time. Let's subscribe to it and see how it updates as we load the model.

```dart
final listener = model.stateX.listen((state) => print(state));
await model.load();
model.getOrNull(); // ApiData

// PRINTS
// FutureValue.empty()
// FutureValue.loading()
// FutureValue.loaded(ApiData)
```

Whenever you want to reload the data from the API (for example, when the user hits a "Refresh" button), you can simply call `model.load()` to reload the data.

Look at the documentation for the [model](../model/README.md) package to see how you can render Models in Flutter.

## Mapping Models

Sometimes you may have a Model, but need to transform the result of the loaded value to something else. For example, if there is a function like:

```dart
Model<ApiData> getModelFromWebsite(String apiUrl) {...}
```

You may want to use the function's Model as a base, but only retrieve the response code. You can map the Model like so:

```dart
final responseCodeModel = getModelFromWebsite('https://www.example.com').map((response) => response.code);
```

With `responseCodeModel`, you get only the part of the Model you need.

You can chain `map`s together to compose Models exactly how you want them.

## Loading

Consider the following:

```dart
final model1 = Model(() => aRandomInt());
final model2 = model1.map((value) => value.toString())
```

`model2` depends on `model1`. If you call `model1.load()`, it will set its value to a new random int, which will also adjust the value of `model2` to the string version of it. Similarly, calling `model2.load()` will also reload `model1` since `model2` depends on `model1`.

This can come in useful if you have a base Model that is used by many other Models. For example, a `settingsModel` which will return a JSON of the settings of the user. You may want to create separate Models that map to specific attributes from the `settingsModel` like `settingsColorModel = settingsModel.map((settings) => settings['color'])`. If you update the `settingsModel`, all other Models that depend on it will be updated as well, which you can use to update your UI.

## Transforming Models

Here are other ways you can transform Models:

- `asyncMap`: Map a Model to another value asynchronously. So, loading `model.asyncMap((value) async => await myFuture(value))` will load `model` and use its value to compute the result of `await myFuture(value)`. While the Future is being processed, the entire Model is considered "loading" until it is done.
- `flatMap`: Map a Model to another Model. So, loading `model.flatMap((value) => someOtherModel(value))` will load `model` and use its value to create another Model, and load that Model. The entire Model is considered "loading" until the generated Model completes loading.
