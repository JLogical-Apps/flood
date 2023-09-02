# Model

This package exports utilities to help use Models in your Flutter applications.

## ModelBuilder

Models can be in one of 4 states: empty, loading, loaded, or error. If you want to render the result of a Model, it can be quite tedious to listen to the value stream of the model, check the state of the Model, and render widgets depending on its state. As a result, `ModelBuilder` was born to simplify the process of rendering a Model.

Simply insert a Model and a Builder, and voila, your Model will be listened to, and if the state of the Model is loaded, it will use the builder to build the Widget representing that value.

For example,

```dart
Widget build(BuildContext context) {
  final settingsModel = useMemoized(() => getSettingsModel());
  return ModelBuilder(
    model: settingsModel,
    builder: (Settings settings) {
      return ...;
    }
  );
}
```

The `ModelBuilder` will run the builder with the loaded value of `settingsModel`. While the Model is loading, it will render a `StyledLoadingIndicator()` (this can be overridden by passing in a `loadingIndicator` to the `ModelBuilder`). If the Model has an error, it will print the error and render it using `StyledText.body.error()` (this can be overridden by passing in an `errorBuilder` to the `ModelBuilder`). If the Model is loaded, it will use the `builder` to generate the child.

## Model Hooks

There are a few hooks can be helpful when using `flutter_hooks`.

- `useModel(Model model)`: This will listen to the state of the Model and return the current state of the Model.
- `useModels(List<Model> models)`: This will listen to the state of all the Models and return a list of the states of each of the Models.
- `useFutureModel(() async => await myFuture())`: This will create a new Model based on the Future you create, listen to that Model, and return the Model that was generated. You can then call `model.load()` to run that Future again to update the state of the Model.
