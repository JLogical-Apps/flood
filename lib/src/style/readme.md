# Motivation
Designing the front-end and back-end of an app are two very different tasks. Instead of having to change your focus from data manipulation to adjusting the padding of a container, the styling system will separate and abstract the concept of styling. Some of the benefits of using the styling system include:
- Quicker full-stack development since styling concerns are abstracted away.
- Consolidating all front-end related tasks in one system instead of being dispersed all throughout the app.
- Less intermingling of developer code. Front-end and back-end development will not interfere with one another. 
- Simply plug in and use a variety of styles in your app.

# Principles
- The app will use a `Style`. A Style defines how `StyledWidgets` will be rendered. A `Style` can be configured when it is created.
- There are a variety of basic `StyledWidgets` including `StyledText`, `StyledButton`, `StyledTextField`, `StyledContent`, `StyledPage`, etc.
- `StyledWidget`s receive a `StyleContext` from their parents and pass it along to the `Style` to be fully rendered.
- Every time a widget wants to provide a new `StyleContext` to its children, use a `StyleContextProvider` with the `StyleContext` to pass along.
- Some `StyledWidget`s have an emphasis that will change how they are rendered. For example, `StyledContent.high(...)` will be rendered with more attention-grabbing colors than `Styledcontent.low(...)`.
- A `StyleContext` contains colors that `StyledWidget`s use to color themselves. There is a background color, foreground color, and emphasis color. There is also a soft variant of each of these that has a slight contrast with the main color.

# Usage
- View the Example's Style section.