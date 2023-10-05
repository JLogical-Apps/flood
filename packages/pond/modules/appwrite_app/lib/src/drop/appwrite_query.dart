import 'package:appwrite/appwrite.dart';

class AppwriteQuery {
  final Databases databases;
  final String collectionId;
  final List<String> queries;

  const AppwriteQuery({required this.databases, required this.collectionId, this.queries = const []});

  AppwriteQuery copyWith({String? collectionId, List<String>? queries}) {
    return AppwriteQuery(
      databases: databases,
      collectionId: collectionId ?? this.collectionId,
      queries: queries ?? this.queries,
    );
  }

  AppwriteQuery withQuery(String query) {
    return copyWith(
      queries: queries + [query],
    );
  }
}
