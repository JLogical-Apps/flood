# Port Style Component

This package exports `PortStyleAppComponent` which allows you to pass in `StyledObjectPortOverride`s to override the auto-generated Widgets for a `Port<T>` of type `T`.

## Overriding

If you have a `User` and want to override what its edit dialog looks like when calling `context.showDialog(StyledDialog.port(userPort))`, you can create an implementation of `IsStyledObjectPortOverride<User>`:

```dart
class UserPortOverride with IsStyledObjectPortOverride<User> {
  @override
  Widget build(Port port) {
    return StyledObjectPortBuilder(
      port: port,
      order: [
        User.nameField,
        User.emailField,
      ],
    );
  }
}
```

and pass it into the `PortStyleAppComponent`.

This will override the widget used when building a `Port<User>`. In this case, you are still building using auto-generated Widgets (because of the `StyledObjectPortBuilder`), you are simply overriding the order of the fields.
