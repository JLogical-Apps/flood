# Style

This package exports an entire styling system to help with theming your app automatically.

## Style

`Style`s have a few purposes:

1. Define how to render `StyleComponent`s. A `StyleComponent` is a Widget that simply calls on the current BuildContext's `Style` to render it.
2. Define a `ColorPalette`, which is used to determine what colors to use based on a background color.
3. Define what the `TextStyle` of a `StyledText` is.
4. Define how to show `StyledDialog`s and `StyledMessage`s.
5. Define a `Styleguide`, which can be used to preview the `StyleComponent`s of the `Style`.

A default `Style` is provided: `FlatStyle`.

## Color Palette

A `ColorPalette` defines how to get a background and foreground color given a background color and an `emphasis`. For example, say you have a Widget with a light-gray background. If you want to add some text and a button, here is how you would find what colors to use for that Widget.

```dart
// Inside the light-gray widget.
final colorPalette = context.colorPalette();
final textColor = colorPalette.foreground.regular; // Use foreground.strong for an emphasized text, or foreground.subtle for subtle text.
final buttonBackgroundColor = colorPalette.background.regular; // Use background.strong or background.subtle to define emphasis.
final buttonTextColor = buttonBackgroundColor.foreground.regular; // [buttonBackgroundColor] is both a `Color` and a `ColorPalette`, so you can see wha the text's foreground color should be.
```

## Customization

To customize a `Style`, you can add a new `StyleRenderer` to the `Style`. For example, if you want to update how `StyledCard`s are rendered, you can define a style like `FlatStyle()..addRenderer(MyStyledCardRenderer());`. You will need to define `MyStyledCardRenderer()` as a `IsTypedStyleRenderer<StyledCard>` and implement the appropriate methods.

## Text

Adding `StyledText`s is very easy because you can compose their styles without needing to be too verbose.

Use the static `StyledText.{TEXT_TYPE}` constructor as the base of a `StyledText`. For example, `StyledText.body`, `StyledText.body`, or `StyledText.twoXl`. Then, you can add modifiers, such as `.bold`, `.strong`, `.centered`, or `.error` to modify the `StyledText`. Once you are done with the modifiers, simply add `()` afterwards with the text you want rendered inside. For example, instead of this:

```dart
Text(
  'Check this out!',
  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: context.colorPalette().foreground.strong,
    fontStyle: FontStyle.italic,
  ),
  textAlign: TextAlign.center,
);
```

you can write this:

```dart
StyledText.body.strong.centered.italics('Check this out!')
```

## Padding

The `Style` system also handles padding your widgets so everything doesn't seem clumped together. The general pattern for how this works is that widgets that have children will define the padding for their children (instead of children defining padding for themselves). So, a `StyledList.column` is different than a `Column` in the fact that it adds internal padding to its children _for you_, so you don't have to wrap each child in a `Padding` widget.

## Useful StyleComponents

While this won't go through every `StyleComponent`, here are a few that are very useful:

- `StyledList.column` and `StyledList.row`: Similarly to `StyledText`, you can compose additional attributes to Columns and Rows, such as `.centered`, `.withScrollbar`, and `.withMinChildSize(size)` to create a grid effect.
- `StyledContainer`: A highly customizable widget that handles child padding, finding the right color for the given emphasis, etc.
- `StyledCard`: A great choice to display content inside of. It also has options for emphasis (`StyledCard.strong` for example).
- `StyledMarkdown`: Parses markdown and converts it into `StyledText`s. For example, `` Regular _italic_ **bold** `code`  `` will render the text with italicized, bolded, and strong `StyledText`s accordingly.
