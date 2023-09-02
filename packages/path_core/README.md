# Path (Core)

This package exports utilities to generate Paths and Routes.

## Routing

In the context of Flutter Web or building an API, you need routes. A route will grab a URL and return the associated Widget or Task. The `Path` package allows you to easily define what the routes of your app are, and also help construct the associated Widgets or Tasks. For example, if you navigate to `/envelope/asdf`, you may define that to open an `EnvelopePage` and you may want to set the `idProperty` of the `EnvelopePage` to `asdf`. `Path` will take care of all that for you.

## Path Definitions

A URL can be broken down into a list of segments along with some query parameters. For example, `/parent/child?property=1` is defined as navigating to `/parent/child` with an additional attribute that `property` = `1`.

Using `Path`, you can define a `PathDefinition`, which will return whether a given URL matches the path. For example:

```dart
final childPath = PathDefinition.string('parent').string('child');
childPath.matches('/parent/child?property=1') // true
childPath.matches('/some/other/path') // false
childPath.matches('/parent/other') // false
```

Each of the `.string()` modifiers represents a String in the URL.

Notice that the third example does not match. If you want to allow any arbitrary value after `/parent`, you can use `.wildcard()` which will pass as long as it fits within that one segment.

```dart
final childDirectory = PathDefinition.string('parent').wildcard();
childPath.matches('/parent/child?property=1') // true
childPath.matches('/some/other/path') // false
childPath.matches('/parent/other') // true
```

You can also pass along properties (we'll discuss how to use this later) which will set the property to the value in the URL when it matches that segment.

```dart
final envelopePath = PathDefinition.string('envelope').property(myEnvelopeIdProperty);

usePathToGenerateProperties(envelopePath, '/envelope/123') // <-- We'll discuss how to actually set the property below.

myEnvelopeIdProperty.value // '123'
```

As you can see here, `myEnvelopeIdProperty` was set to the value `123` because that's what was passed in the URL for that segment of the URL.

Let's see how to actually take advantage of this powerful feature with Routes.

## Route

A `Route` is an abstract class you can extend. A `Route` has 3 primary goals:

1. Define a `PathDefinition`: The `PathDefinition` defines whether the `Route` matches a given URL.
2. Set properties based on a path: You can define both segment properties and query properties which will be set based on a path.
3. Define how to generate a copy of that class. I'll explain why later.

Here's an example of a `Route`:

```dart

class EnvelopeRoute with IsRoute<EnvelopeRoute>, IsPathDefinitionWrapper {
  late final envelopeIdProperty = field<String>(name: 'id').required();
  late final budgetIdProperty = field<String>(name: 'budgetId').required();
  late final trayIdProperty = field<String>(name: 'trayId');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(envelopeIdProperty);

  @override
  List<RouteProperty> get queryProperties => [budgetIdProperty, trayIdProperty];

  @override
  EnvelopeRoute copy() {
    return EnvelopeRoute();
  }
}
```

Notice that `EnvelopeRoute` defines three properties: `envelopeIdProperty`, `budgetIdProperty`, and `trayIdProperty`. `envelopeIdProperty` is a String property that is `.required()`, meaning it cannot be null. It is used as part of the `PathDefinition`. `budgetIdProperty` is also a required String property, but it is used as one of the query properties. `trayIdProperty` is a non-required String property which is used as one of the query properties.

We also define a `copy()` method which will generate a new `EnvelopeRoute` for us. We do this so that there is a "definition" `Route` which simply handles matching paths, and once a path matches a `Route`, it will spawn a child where the properties are set based on the path.

Take a look at this example:

```dart
final routeDefinition = EnvelopeRoute();
final route = routeDefinition.fromPath('/envelope/myEnvelope?budgetId=myBudget&trayId=myTray');
route.envelopeIdProperty.value // 'myEnvelope'
route.budgetIdProperty.value // 'myBudget'
route.trayIdProperty.value // 'myTray'
```

We create a `routeDefinition` which is immutable. We then pass a path along to it, which will create a new `EnvelopeRoute` (using `copy()`) and set its properties. Notice that it set `budgetIdProperty` and `trayIdProperty` based on the query parameters at the end of the URL.

Because `budgetIdProperty` is a required field, if you attempted to call `.fromPath()` without a `budgetId` as a query parameter, it would throw an Exception. Before calling `.fromPath()`, it is recommended to check whether the URL is valid using `.matches()` first.
