# Pond

This package exports utilities to build an app based on Pond.

## AppPondContext

Like discussed in [pond_core](../pond_cli/README.md), a `CorePondContext` contains `CorePondComponent`s. There are some limitations with `CorePondComponent`s; they cannot depend on Flutter. So, registering components to help you with focus management, adding a URL bar, or adding a debug page would be impossible since those depend on Flutter.

This package adds another context, the `AppPondContext`, which wraps `CorePondContext` and allows you to add `AppPondComponent`s. Similarly to a `CorePondComponent`, an `AppPondComponent` allows you to define what happens when it's registered or loaded, but it also allows you to define any `AppPage`s to be added, and you can define how to wrap every `AppPage`.

For example, the [style_component](../modules/style_component/README.md)'s `StyleAppComponent` wraps the entire app in a `StyleProvider` so that all the `StyleComponent`s have a `Style` as an ancestor. Not only that, it adds a `StyleguidePage` which allows you to view the current `Style`'s `Styleguide` at the url `/_styleguide`.

## PondApp

To simplify running an app based on an `AppPondContext`, you can simply use `PondApp` in your `app.dart` file as your base Widget. This will handle running a splash screen while your `AppPondContext` loads, wrapping all your widgets and pages with the definitions from the `AppPondComponent`s, and handling all the URL navigation for you.

For example:

```dart
Future<void> main(List<String> args) async {
  await PondApp.run(
    appPondContextGetter: () async => await getAppPondContext(),
    splashPage: StyledPage(
      body: Center(
        child: StyledLoadingIndicator(),
      ),
    ),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.h1('Not Found!'),
      ),
    ),
    initialPageGetter: () => HomePage(),
    onError: (appPondContext, error, stackTrace) {
      if (appPondContext == null) {
        print(error);
        print(stackTrace);
      } else {
        appPondContext.find<LogCoreComponent>().logError(error, stackTrace);
      }
    },
  );
}
```

And voila, after your app has finished initialization, you will be directed to the `HomePage`.

## AppPages

In order to support Flutter Web, `PondApp` will handle any URLs by finding the associated registered `AppPage` definition, create a new instance, and build the Widget. You need to create `AppPage`s and register them to an `AppPondComponent` in order for `PondApp` to know how to direct urls.

An `AppPage` is a `HookWidget` composed of:

- `pathDefintion`: Defines the route of your page. See [path](../../path_core/README.md) for more info.
- `build()`: Defines how to build the page.
- `redirectTo()`: A function that is run before initially being shown. If it returns a non-null Uri, it will redirect the user to that page instead of this one. For example, if you are navigating to a `HomePage` but aren't logged in, you can get redirected to the `LoginPage` first.
- `getParent()`: When navigating to this page from a new tab, this will allow you to immediately render the parent first before this `AppPage`. That way, there is a back button on the top-left corner immediately. For example, the parent of a `ProjectPage` could be the `HomePage`.

Here's an example of an `AppPage`:

```dart

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    return StyledPage(titleText: idProperty.value);
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(idProperty);

  @override
  AppPage copy() {
    return EnvelopePage();
  }

  @override
  AppPage? getParent() {
    return HomePage();
  }
}

```

When you register this to an `AppPondComponent` then navigate to `/envelope/asdf`, `PondApp` will render an `EnvelopePage` whose `idProperty` has been set to `asdf`.

## Utilities

Given a `BuildContext`, you can call `context.find<MyComponent>()` which will return the `AppPondComponent` or `CorePondComponent` with that type.
