import 'package:example/pond/presentation/pond_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class VideoPage extends HookWidget {
  final String assetId;

  const VideoPage({required this.assetId});

  @override
  Widget build(BuildContext context) {
    final asset = useAsset(assetId).getOrNull();
    final size = MediaQuery.of(context).size;
    return StyleProvider(
      style: PondLoginPage.style,
      child: StyledPage(
        backgroundColor: Colors.black,
        body: asset == null
            ? StyledLoadingIndicator()
            : StyledLoadingAsset.loaded(
                width: size.width,
                height: size.height,
                asset: asset,
              ),
      ),
    );
  }
}
