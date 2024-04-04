import 'package:firebase/src/firebase_core_component.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

extension FirebaseCorePondContextExtensions on CorePondContext {
  FirebaseCoreComponent get firebaseCoreComponent => locate<FirebaseCoreComponent>();
}

extension FirebaseAppPondContextExtensions on AppPondContext {
  FirebaseCoreComponent get firebaseCoreComponent => find<FirebaseCoreComponent>();
}

extension FirebaseBuildContextExtensions on BuildContext {
  FirebaseCoreComponent get firebaseCoreComponent => find<FirebaseCoreComponent>();
}
