# Ops

This package exports `OpsAutomateComponent` which allows you to easily manage deploying resources to operational environments such as Firebase.

## OpsAutomateComponent

Pass `environments` which maps a [environmentType](../environment_core/README.md) to its `OpsEnvironment`. When running `dart tool/automate.dart deploy [environmentType]`, `OpsAutomateComponent` will find the `OpsEnvironment` associated with that environmentType and deploy resources to that environment.

## OpsEnvironment

Here are the currently supported `OpsEnvironment`s:

- `OpsEnvironment.firebaseEmulator`: This generates and deploys security rules to the Firebase emulators. If they are not running, it will install and run the emulators for you.
- `OpsEnvironment.firebase`: This generates and deploys security rules to a Firebase project.
