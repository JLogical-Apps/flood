# Release

This package exports `ReleaseAutomateComponent`, designed to simplify and manage your app's releases to app stores and testing frameworks.

## Motivation

Deploying applications across different platforms is a complex process that demands consistency, flexibility, and reliability. The `Release` system addresses these concerns:

- **Consistency** : By defining pipelines for different release types (e.g., beta, alpha, production), you ensure a uniform deployment process across environments.
- **Flexibility** : Adapt the release process to various scenarios with the ability to selectively skip certain steps or target specific platforms.
- **Ease of Use** : Initiate the release process for different environments and platforms with a single, intuitive command.

## Setup

Integrating the `Release` system in your Dart project involves a few simple steps:

```dart

await automatePondContext.register(ReleaseAutomateComponent(pipelines: {
    ReleaseEnvironmentType.beta: Pipeline.defaultDeploy({
      ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.internal, isDraft: true),
      ReleasePlatform.ios: DeployTarget.testflight,
      ReleasePlatform.web: DeployTarget.firebase(channel: 'beta'),
    }),
    ReleaseEnvironmentType.production: Pipeline.defaultDeploy({}),
}));
```

In the configuration above:

- The `beta` environment pipeline deploys Android builds to Google Play (as a draft release), iOS builds to Testflight, and web builds to Firebase under the `beta` channel.

The default pipeline follows these steps:

- `version`: Overrides the versions in `pubspec.yaml` and XCode.
- `release_notes`: Incorporates release notes into the changelogs for Testflight and Google Play.
- `test`: Executes `dart test`.
- `build`: Compiles the app for the chosen release platforms.
- `deploy`: Dispatches the build to the designated deploy targets.

### Customization

You have the freedom to customize the Dart setup:

- **Targeting Other Platforms** : By extending the `ReleasePlatform` enumeration, you can include additional platforms.
- **Custom Deploy Targets** : Add more deploy targets by creating custom instances of the `DeployTarget` class.
- **Custom Pipelines** : Tailor pipelines to your specific needs by adding or modifying the pipeline's steps.

## Usage

### First-time Run

When running a pipeline for the first time, the `Release` system provides an interactive setup to gather the necessary secrets and credentials. This ensures that your deployments are secure and only accessible to authorized personnel.

### Command Arguments:

- **Environment** : This is the first argument and specifies the release environment (`beta`, `alpha`, or `production`).
- **skip\_[step_name]** : Skip a specific step in the pipeline. For instance, `skip_test:true` will omit the testing phase.
- **only** : Restrict the release process to certain platforms by providing a comma-separated list, like `only:android,ios` to release only for Android and iOS.

Using the system involves issuing commands like:

1. **Beta Release**

```bash
dart tool/automate.dart release beta
```

2. **Alpha Release with Skipped Steps**

```bash
dart tool/automate.dart release alpha skip_deploy:true skip_test:true
```

3. **Production Release for Specific Platforms**

```bash
dart tool/automate.dart release production only:android,ios
```

By understanding and leveraging these arguments, you can achieve a wide range of release scenarios tailored to your project's needs.
