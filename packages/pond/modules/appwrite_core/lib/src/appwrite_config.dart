class AppwriteConfig {
  final String endpoint;
  final String projectId;
  final bool? selfSigned;
  final String? apiKey;

  AppwriteConfig({required this.endpoint, required this.projectId, this.selfSigned, this.apiKey});

  AppwriteConfig.localhost({required this.projectId})
      : endpoint = 'http://localhost/v1',
        selfSigned = true,
        apiKey = null;

  AppwriteConfig.cloud({required this.projectId})
      : endpoint = 'https://cloud.appwrite.io/v1',
        selfSigned = false,
        apiKey = null;

  AppwriteConfig.apiKey({required this.projectId, required this.apiKey, required this.endpoint}) : selfSigned = true;
}
