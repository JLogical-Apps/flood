import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_cloud_repository.dart';

class FirebaseCloudRepositoryImplementation with IsRepositoryImplementation<CloudRepository> {
  @override
  Repository getImplementation(CloudRepository prototype) {
    return FirebaseCloudRepository(cloudRepository: prototype);
  }
}
