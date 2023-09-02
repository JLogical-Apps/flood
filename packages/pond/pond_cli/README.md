# Pond (CLI)

This package exports utilities to build CLI tools based on Pond.

## AutomatePondContext

Like discussed in [pond_core](../pond_cli/README.md), a `CorePondContext` contains `CorePondComponent`s. There are some limitations with `CorePondComponent`s; they cannot depend on any CLI libraries. So, registering components to add support to automate building your app would be impossible.

This package adds another context, the `AutomatePondContext`, which wraps `CorePondContext` and allows you to add `AutomatePondComponent`s. Similarly to a `CorePondComponent`, an `AppPondComponent` allows you to define what happens when it's registered or loaded, but it also allows you to define any `AutomateCommand`s to be added.

## Automation Setup

Using automation can be very helpful to run commands to _build_ your app, or to run commands to setup environments. When you run `dart tool/automate.dart` from your core project, you will see a list of the `AutomateCommand`s that have been registered to your project. Running `dart tool/automate.dart my_command_name` will run the `AutomateCommand` with `my_command_name`.

To get started using automation, add an `automate.dart` under the `tool` directory of your core project with these contents:

```dart
Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext();
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  await automatePondContext.register(AppIconAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground_transparent.png',
    backgroundColor: 0x172434,
    padding: 80,
  ));
  await automatePondContext.register(OpsAutomateComponent(environments: {
    EnvironmentType.static.qa: OpsEnvironment.static.firebaseEmulator,
    EnvironmentType.static.staging: OpsEnvironment.static.firebase,
    EnvironmentType.static.production: OpsEnvironment.static.firebase,
  }));

  await Automate.automate(
    context: automatePondContext,
    args: args,
    appDirectoryGetter: (coreDirectory) => coreDirectory.parent / 'example',
  );
}
```

In this example, we are registering a few `AutomateComponents` which allow us to set the app icon of the app and to deploy security rules to Firebase.

## AutomateCommand

An `AutomateCommand` is composed of:

- `name`: The name of the command you need to type to run.
- `description`: A brief description of the command to be shown in the help dialog.
- `AutomatePathDefinition pathDefinition`: A definition for what to do with extra segments at the end of the `name`. For example, `dart tool/automate.dart deploy staging` will run the `DeployAutomateCommand` and pass in `staging` to the `environmentProperty` because its `pathDefinition` is set to `AutomatePathDefinition.property(environmentProperty)`
- `parameters`: A list of properties that can be set with optional parameters. For example, `dart tool/automate.dart deploy staging dryrun:true` will set `dryrun` to true if it's one of its `parameters`.
- `copy()`: Creates an instance of the command.
- `onRun()`: Runs the command.
