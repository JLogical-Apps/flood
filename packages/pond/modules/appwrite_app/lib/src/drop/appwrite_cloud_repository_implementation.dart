import 'package:appwrite_app/src/drop/appwrite_cloud_repository.dart';
import 'package:drop_core/drop_core.dart';

class AppwriteCloudRepositoryImplementation with IsRepositoryImplementation<CloudRepository> {
  @override
  Repository getImplementation(CloudRepository prototype) {
    return AppwriteCloudRepository(cloudRepository: prototype);
  }
}
