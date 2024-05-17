import 'package:equatable/equatable.dart';

class AssetMetadata extends Equatable {
  final String? mimeType;
  final int size;
  final DateTime createdTime;
  final DateTime updatedTime;

  AssetMetadata({
    required this.mimeType,
    required this.size,
    required this.createdTime,
    required this.updatedTime,
  });

  AssetMetadata copyWith({required String? mimeType, int? size, DateTime? createdTime, DateTime? updatedTime}) {
    return AssetMetadata(
      mimeType: mimeType,
      size: size ?? this.size,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  AssetMetadata withCreatedAt(DateTime dateTime) {
    return copyWith(
      mimeType: mimeType,
      createdTime: dateTime,
    );
  }

  AssetMetadata withUpdatedAt(DateTime dateTime) {
    return copyWith(
      mimeType: mimeType,
      updatedTime: dateTime,
    );
  }

  @override
  List<Object?> get props => [mimeType, size, createdTime, updatedTime];
}
