# Port

This package exports widgets to help use `Port`s in your Flutter application.

## PortBuilder

Use a `PortBuilder` to listen to the values of a `Port` and build some Widgets based on its value.

For example:

```dart
PortBuilder(
  port: port,
  builder: (context, port) {
    ... // Widgets to render the PortFields.
  }
)
```

## PortFieldBuilder

Use a `PortFieldBuilder` to listen to the value of a specific `PortField` and build a Widget based on its value. `PortFieldBuilder`s must be a child of a `PortBuilder`.

For example:

```dart
PortFieldBuilder(
  fieldName: 'name',
  builder: (context, portField, value, error) {
    return StyledText.body(value ?? 'Error: $error');
  }
)
```

## Full Example

This example will show you how you can use [port_style](../port_style/README.md) to render a Port, update its values, and submit it.

```dart
final loginPort = useMemoized(() => Port.of({
          'email': PortField.string().isNotBlank().isEmail(),
          'password': PortField.string().isNotBlank(),
        }));

return PortBuilder(
  port: loginPort,
  builder: (context, port) {
    return StyledList.column.centered.withScrollbar(
      children: [
        StyledTextFieldPortField(
          fieldName: 'email',
          labelText: 'Email',
        ),
        StyledTextFieldPortField(
          fieldName: 'password',
          labelText: 'Password',
          obscureText: true,
        ),
        StyledList.row.centered.withScrollbar(
          children: [
            StyledButton(
              labelText: 'Login',
              onPressed: () async {
                final result = await loginPort.submit();
                if (!result.isValid) {
                  return;
                }

                final data = result.data;

                try {
                  final userId = await context.find<AuthCoreComponent>().login(data['email'], data['password']);
                  onLoggedIn(userId);
                } catch (e, stackTrace) {
                  final errorText = e.as<LoginFailure>()?.displayText ?? e.toString();
                  loginPort.setError(name: 'email', error: errorText);
                  context.logError(e, stackTrace);
                }
              },
            ),
            StyledButton.strong(
              labelText: 'Sign Up',
              onPressed: () async {
                final result = await loginPort.submit();
                if (!result.isValid) {
                  return;
                }

                final data = result.data;

                try {
                  final userId = await context.find<AuthCoreComponent>().signup(data['email'], data['password']);

                  onSignedUp(userId);
                } catch (e, stackTrace) {
                  final errorText = e.as<SignupFailure>()?.displayText ?? e.toString();
                  loginPort.setError(name: 'email', error: errorText);
                  context.logError(e, stackTrace);
                }
              },
            ),
          ],
        ),
      ],
    );
  },
);
```
