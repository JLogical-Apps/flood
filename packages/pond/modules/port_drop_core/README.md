# Port Drop Core

This package exports `PortDropCoreComponent` which allows you to generate [Port](../../../port/port_core/README.md)s from a [ValueObject](../drop_core/README.md).

## Generating a Port

To generate a `Port` from a `ValueObject`, simply call `context.find<PortDropCoreComponent>().generatePort(myValueObject)`. This will examine all the behaviors of `myValueObject` and generate `PortField`s based on those. The `Port` has a `.map` which will convert the final `Port` back into a `ValueObject`. So you can use this to generate `Port`s for `ValueObject`s easily, edit a `ValueObject`, and save it back to a `Repository` without explicitly defining a `toPort` method or defining the Widgets for the edit dialog.

## Modifiers

Some modifiers of a `ValueObject`'s behaviors modify how the `PortField` is generated. Consider these:

- `.withDisplayName()`: Shows a label for the field.
- `.hidden()`: Prevents the field from being generated in the `Port`.
- `.withPlaceholder()`/`.withFallback()`: Shows a hint of the fallback if no value is set.
- `.multiline()`: Shows a multiline text field.
- `.withDefault()`: Sets a default value when first loading the `Port` and no value currently exists.
- `.requiredOnEdit()`: Required in the `Port`.

## Overriding

Sometimes you need to customize the generated `PortField`s. You can use `overrides` in `generatePort()` to accomplish this:

- `PortGeneratorOverride.remove(field)`: Removes the `field` from the `Port`.
- `PortGeneratorOverride.override(field, portField)`: Overrides the `field` to use `portField` instead of an auto-generated one.
- `PortGeneratorOverride.update(field, portFieldBuilder)`: Add modifiers to the `field`'s auto-generated `portField`
