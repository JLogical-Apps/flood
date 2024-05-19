import 'package:asset/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledAssetPortField<E, T> extends HookWidget {
  final String fieldPath;

  final AllowedFileTypes? allowedFileTypes;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  const StyledAssetPortField({
    super.key,
    required this.fieldPath,
    this.allowedFileTypes,
    this.labelText,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<AssetPortValue>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        final label = this.label ?? labelText?.mapIfNonNull((labelText) => StyledText.body.bold.display(labelText));

        final assetField =
            (field.findAssetFieldOrNull() ?? (throw Exception('Could not find asset field for [$field]')));

        return StyledList.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Padding(
                padding: const EdgeInsets.all(4),
                child: label,
              ),
            StyledList.row(
              children: [
                Expanded(
                  child: Center(
                    child: value.uploadedAsset != null
                        ? AssetBuilder.buildAsset(value.uploadedAsset!, height: 140)
                        : (value.removed || value.initialValue == null
                            ? StyledText.sm('No asset')
                            : AssetReferenceBuilder.buildAssetReference(value.initialValue!, height: 140)),
                  ),
                ),
                StyledList.column.centered(
                  children: [
                    if ((value.initialValue != null || value.uploadedAsset != null) && !value.removed) ...[
                      StyledButton(
                        iconData: Icons.swap_horiz,
                        onPressed: () async {
                          final newAsset = await AssetPicker.select(context, allowedFileTypes ?? AllowedFileTypes.any);
                          if (newAsset != null) {
                            port[fieldPath] = assetField.value.withUpload(newAsset);
                          }
                        },
                      ),
                      StyledButton(
                        iconData: Icons.remove_circle,
                        onPressed: () => port[fieldPath] = assetField.value.withRemoved(),
                      ),
                    ],
                    if (value.removed || (value.initialValue == null && value.uploadedAsset == null))
                      StyledButton(
                        iconData: Icons.upload,
                        onPressed: () async {
                          final newAsset = await AssetPicker.select(context, allowedFileTypes ?? AllowedFileTypes.any);
                          if (newAsset != null) {
                            port[fieldPath] = assetField.value.withUpload(newAsset);
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
            if (error != null)
              Center(
                child: StyledText.body.bold.error(error),
              ),
          ],
        );
      },
    );
  }
}
