import 'package:drop_core/drop_core.dart';
import 'package:appwrite_core/src/drop/appwrite_cloud_repository.dart';

class AppwriteCloudRepositoryImplementation with IsRepositoryImplementation<CloudRepository> {
  @override
  Repository getImplementation(CloudRepository prototype) {
    return AppwriteCloudRepository(cloudRepository: prototype);
  }
}
