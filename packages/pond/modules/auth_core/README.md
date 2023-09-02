# Auth (Core)

This package exports `AuthCoreComponent`, which adds the ability to login, signup, and logout of accounts.

## AuthCoreComponent

Provide an `AuthService authService` which is what will be used to handle authentication. Examples of `AuthService`s are:

- `AuthService.static.file()`: Use the device file system.
- `AuthService.static.cloud()`: Use a cloud provider's auth.
- `AuthService.static.adapting()`: Choose an `AuthService` depending on the current [environment](../environment_core/README.md)

Since this package cannot depend on Flutter, you'll need to provide `implementations` if you are using an `AuthService` that may need Flutter dependencies. For example, `firebase_auth` requires Flutter dependencies to work, so you will need to pass in `FirebaseAuthServiceImplementation()` to use it.

## AuthService

An `AuthService` allows you `login()`, `signup()`, `logout()`, and get `loggedInUserId`.

## Reset

When the `CorePondContext` is reset, it will automatically log out of the currently logged-in account.
