# Debug

This package exports `DebugAppComponent`, which adds the ability to overlay debug information when `?_debug=true` is at the end of the URL, and adds a debug page at `/_debug`.

## Debug Page

A debug page is added to `/_debug`. Any `AppPondComponent`s that implement `IsDebugPageComponent` will be shown in the debug page along with a button to view that debug panel in more detail. An example of this is [reset](../reset/README.md)'s `ResetAppComponent`.

## Debugging

When you add `?_debug=true` to the end of a URL, an inspector button appears on the top-right corner. Clicking it will reveal an overlay with more debugging information about the current page. An example of this is [auth](../auth/README.md)'s `AuthAppComponent`.
