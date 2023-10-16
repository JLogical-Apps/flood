class AppwriteConfig {
  final String endpoint;
  final String projectId;
  final bool selfSigned;

  AppwriteConfig({required this.endpoint, required this.projectId, this.selfSigned = false});

  AppwriteConfig.localhost({required this.projectId})
      : endpoint = 'http://localhost/v1',
        selfSigned = true;

  AppwriteConfig.cloud({required this.projectId})
      : endpoint = 'https://cloud.appwrite.io/v1',
        selfSigned = false;
}
