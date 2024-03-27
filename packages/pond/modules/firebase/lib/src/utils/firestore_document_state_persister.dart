import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_timestamp_state_persister_modifier.dart';

StatePersister<Map<String, dynamic>> getDocumentSnapshotPersister(DropCoreContext context) => StatePersister.json(
      context: context,
      extraStatePersisterModifiers: [
        FirebaseTimestampStatePersisterModifier(),
      ],
    );
