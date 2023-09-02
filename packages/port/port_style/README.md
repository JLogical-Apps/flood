# Port (Style)

This package exports widgets from the [style](../../style/README.md) package that can be used to render a `Port` automatically.

## Rendering a Port

There are a variety of ways to render a `Port`:

- As a dialog: Use `context.showDialog(StyledPortDialog(port: port))` to show a dialog with the auto-generated widgets. Override `onAccept` if you want to adjust the behavior of clicking the "OK" button in the dialog.
- As a widget: Use `StyledObjectPortBuilder(port: port)` to render a Widget that contains the auto-generated widgets.

## Overrides

If you want to override the Widget for a particular `PortField`, you can pass in `overrides` to one of the methods above and `order` to adjust the order of the generated Widgets. For example:

```dart
StyledObjectPortBuilder(
  port: userPort,
  order: [
    User.nameField,
    User.emailField,
  ],
  overrides: {
    User.nameField: StyledTextPortField(
      fieldName: User.nameField,
      labelText: 'OVERRIDE',
    ),
  }
),
```
