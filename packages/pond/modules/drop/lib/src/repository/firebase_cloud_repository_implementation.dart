import 'package:drop/src/repository/firebase_cloud_repository.dart';
import 'package:drop_core/drop_core.dart';

class FirebaseCloudRepositoryImplementation with IsRepositoryImplementation<CloudRepository> {
  @override
  Repository getImplementation(CloudRepository prototype) {
    return FirebaseCloudRepository(cloudRepository: prototype);
  }
}
