# Port (Core)

This package exports utilities to handle defining forms, validating them, and transforming their results.

## Port

A `Port` is a definition of a form. A `Port` has 3 purposes:

- Define the fields of the form.
- Validate the form.
- Transform and return the value of the form.

Here's an example:

```dart
final port = Port.of({
  'name': PortField.string().isNotBlank(),
  'email': PortField.string().isNotBlank().isEmail(),
});

port.setValue(name: 'name', value: 'John Doe');
port.setValue(name: 'email', value: 'john@test.com');

final result = await port.submit();
result.isValid // true
result.data['name'] // 'John Doe'
```

Here, you can see that the `Port` defines 2 fields, sets their values, and submits the form. The result of `port.submit()` can be used to verify whether the submission was valid and to return the final results from the `Port`.

## Fields

There are a few default `PortField`s you can use to get started:

- `PortField.string()`: A non-nullable String.
- `PortField.dateTime()`: A DateTime.
- `PortField.option(options)`: Only allows a value from the given list of options.
- `PortField.port(port)`: Embeds a `Port` as a field. Validates the embedded `Port` before submitting. When submitted, this returns the output of the `Port`.
- `PortField.stage(options, portMapper)`: Provides a list of options and a way to map an option to another `Port`. For example, if you can provide options for different EnvelopeRules, and the portMapper will map each option to an embedded Port for that specific EnvelopeRule.

You can modify `PortField`s to add validation or transform their data:

- `.isNotNull()`: Ensures the value is not null.
- `.isNotBlank()`: Ensures a String `PortField` is not null or blank.
- `.isEmail()`: Ensures a String `PortField` is formatted like an email.
- `.withFallback(fallback)`: If the value is null, use the fallback instead.
- `.map(mapper)`: Maps the value to something else when submitted.
- `.withValidator(validator)`: Requires the `Validator` to pass before submitting.

Not only can you modify the functionality of `PortField`s, you can add metadata to them which could be used when generating their Widget counterparts (reference [port](../port/README.md) for how Port can generate the UI for a `Port`!)

- `.withDisplayName(displayName)`: Indicates the display name to use.
- `.withHint(hint)`: Adds a hint for what the value should be.
- `.isSecret()`: Obscures the text.
- `.multiline()`: Adds a multiline TextField instead of a single-line one.
- `.color()`: Use a color picker instead of a TextField.

## Transforming Data

A `Port`'s default return type is a `Map<String, dynamic>` which maps the keys of the `PortField`s to their submitted value. Sometimes, this can be cumbersome to work with, so you can create a `Port` with `.map(mapper)` to set the return type of the `Port` to something else.

For example:

```dart
final port = Port.of({
  'name': PortField.string().isNotBlank(),
  'email': PortField.string().isNotBlank().isEmail(),
}).map((data, port) => Person(name: data['name'], email: data['email']));
```

When you submit the `port`, its `result` will be of type `Person`, not `Map<String, dynamic>`.
