# Actions (Core)

This package exports `ActionCoreComponent`, which allows you to run `Action`s.

## Actions

`Action`s provide an easy way to monitor and customize how your application handles large operations. For example, signing in is an important part of an app. You can create an `Action` that wraps signing in, which can provide more detailed log outputs and analytics.

Define an action like this:

```dart
final echoAction = Action<String?, String>(name: 'echo', runner: (input) => input ?? (throw Exception('Input cannot be null!')));
```

The `Action` is defined with type parameters `<String?, String>`. `String?` indicates the "input", and `String` indicates the "output" of the `Action`.

Calling `await echoAction('Hello World')` will return `Hello World`. This isn't really useful on its own, but with the power of the `ActionCoreComponent`, we can monitor the `Action`s that run in our application.

## ActionCoreComponent

Register `ActionCoreComponent` to your `CorePondContext` to customize how your `Action`s are run in your application. For example:

```dart
await corePondContext.register(ActionCoreComponent(
  actionWrapper: <P, R>(Action<P, R> action) => action.log(context: corePondContext),
));
```

Every time an `Action` is run, it will log when the `Action` begins, what it completes with, and logs errors along with the inputs passed into it.

## Running Actions

To run an action in a Pond application, simply call `await corePondContext.run(action, input)`.
