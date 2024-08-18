import 'package:asset_core/asset_core.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FlutterCompressionAssetProvider with IsAssetProviderWrapper {
  @override
  final AssetProvider assetProvider;

  FlutterCompressionAssetProvider({required this.assetProvider});

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    if (asset.metadata.isImage) {
      final compressedData = await FlutterImageCompress.compressWithList(
        asset.value,
        minWidth: 800,
        minHeight: 800,
        quality: 50,
      );

      final compressedAsset = asset.copyWith(
          value: compressedData,
          metadata: asset.metadata.copyWith(
            mimeType: asset.metadata.mimeType,
            uri: asset.metadata.uri,
            size: compressedData.length,
          ));

      return await assetProvider.upload(context, compressedAsset);
    } else if (asset.metadata.isVideo) {}

    return assetProvider.upload(context, asset);
  }
}
