# Firebase

This package exports a few `CorePondComponent`s to integrate Firebase into your app.

## FirebaseAuthServiceImplementation

Pass this as an implementation to `AuthCoreComponent` to implement `AuthService.static.cloud()` using Firebase Auth.

## FirebaseCloudRepositoryImplementation

Pass this as an implementation to `DropCoreComponent` to implement `Repository.cloud()` using Firestore.

## FirebaseMessagingCoreComponent

Uses Firebase Messaging to generate device tokens and listen to remote messages.
