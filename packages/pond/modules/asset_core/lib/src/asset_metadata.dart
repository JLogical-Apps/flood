import 'package:equatable/equatable.dart';

class AssetMetadata extends Equatable {
  final String? mimeType;
  final int size;
  final DateTime createdTime;
  final DateTime updatedTime;
  final Uri? uri;

  AssetMetadata({
    required this.mimeType,
    required this.size,
    required this.createdTime,
    required this.updatedTime,
    this.uri,
  });

  bool get isImage => mimeType?.startsWith('image/') ?? false;

  bool get isVideo => mimeType?.startsWith('video/') ?? false;

  AssetMetadata copyWith({
    required String? mimeType,
    int? size,
    DateTime? createdTime,
    DateTime? updatedTime,
    required Uri? uri,
  }) {
    return AssetMetadata(
      mimeType: mimeType,
      size: size ?? this.size,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      uri: uri ?? this.uri,
    );
  }

  AssetMetadata withCreatedAt(DateTime dateTime) {
    return copyWith(
      mimeType: mimeType,
      uri: uri,
      createdTime: dateTime,
    );
  }

  AssetMetadata withUpdatedAt(DateTime dateTime) {
    return copyWith(
      mimeType: mimeType,
      uri: uri,
      updatedTime: dateTime,
    );
  }

  @override
  List<Object?> get props => [mimeType, size, createdTime, updatedTime, uri];
}
