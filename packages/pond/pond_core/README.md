# Pond (Core)

This package exports a component management system to quickly build your apps.

## Pond

`Pond` simply manages `CorePondComponent`s for your app. `Pond` comes with many prebuilt `CorePondComponent`s and allows you to customize your own. You register each `CorePondComponent` in a `CorePondContext`, which you can then initialize and use throughout your app.

Each `CorePondComponent` contains `CorePondComponentBehavior`s which you can use to define how a `CorePondComponent` is:

- Registered: When the `CorePondComponent` is added to a `CorePondContext`. Used for initialization that other `CorePondComponent`s might need when registering.
- Loaded: After all `CorePondComponent`s have been registered, they are all then loaded in sequence.
- Reset: A `CorePondContext` can be reset, which should emulate what the program should look like as if it had never been run before.

Here's an example of setting up a `CorePondContext`:

```dart
final corePondContext = CorePondContext();
await corePondContext.register(MyTestComponent());
// ... Register other components
await corePondContext.load();

// Somewhere else in the code
corePondContext.locate<MyTestComponent>() // MyTestComponent
```

You can read the `README.md` of each prebuilt `CorePondComponent` in the [modules](../modules) directory.
