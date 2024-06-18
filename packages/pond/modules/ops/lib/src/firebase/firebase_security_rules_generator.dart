import 'package:ops/src/firebase/asset/firebase_storage_security_rules_generator.dart';
import 'package:ops/src/firebase/repository/firebase_firestore_security_rules_generator.dart';
import 'package:pond_core/pond_core.dart';

class FirebaseSecurityRulesGenerator {
  String generateFirestoreRules(CorePondContext context) => FirebaseFirestoreSecurityRulesGenerator().generate(context);

  String generateFirebaseStorageRules(CorePondContext context) =>
      FirebaseStorageSecurityRulesGenerator().generate(context);
}
