import 'dart:async';
import 'dart:typed_data';

import 'package:asset_core/asset_core.dart';
import 'package:environment/environment.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:persistence/persistence.dart';
import 'package:utils/utils.dart';
import 'package:video_compress/video_compress.dart';

class FlutterCompressionAssetProvider with IsAssetProviderWrapper {
  @override
  final AssetProvider assetProvider;

  FlutterCompressionAssetProvider({required this.assetProvider});

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    final compressedAsset = await _getCompressedAsset(context, asset);
    return await assetProvider.upload(context, compressedAsset ?? asset);
  }

  Future<Asset?> _getCompressedAsset(AssetPathContext context, Asset asset) async {
    if (asset.metadata.isImage) {
      final compressedData = await FlutterImageCompress.compressWithList(
        asset.value,
        minWidth: 800,
        minHeight: 800,
        quality: 50,
      );

      return asset.copyWith(
          value: compressedData,
          metadata: asset.metadata.copyWith(
            mimeType: asset.metadata.mimeType,
            uri: asset.metadata.uri,
            size: compressedData.length,
          ));
    } else if (asset.metadata.isVideo) {
      if (context.context.context.platform == Platform.web) {
        return null;
      }

      final videoDataSource =
          DataSource.static.rawFile(context.context.context.fileSystem.tempIoDirectory! / 'videos' - asset.id);
      await videoDataSource.set(asset.value);

      final compressedMediaInfo =
          await VideoCompress.compressVideo(videoDataSource.file.path, quality: VideoQuality.LowQuality);
      if (compressedMediaInfo?.file == null) {
        return asset;
      }

      final compressedData = await DataSource.static.rawFile(compressedMediaInfo!.file!).getOrNull();
      if (compressedData == null) {
        return asset;
      }

      return asset.copyWith(
          value: Uint8List.fromList(compressedData),
          metadata: asset.metadata.copyWith(
            mimeType: asset.metadata.mimeType,
            uri: asset.metadata.uri,
            size: compressedData.length,
          ));
    }

    return null;
  }
}
