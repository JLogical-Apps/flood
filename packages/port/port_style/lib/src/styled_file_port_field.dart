import 'package:asset/asset.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledFilePortField extends HookWidget {
  final String fieldPath;

  final AllowedFileTypes? allowedFileTypes;

  final String? labelText;
  final Widget? label;
  final String? hintText;

  final Widget? leading;
  final IconData? leadingIcon;

  final bool enabled;

  const StyledFilePortField({
    super.key,
    required this.fieldPath,
    this.allowedFileTypes,
    this.labelText,
    this.label,
    this.hintText,
    this.leadingIcon,
    this.leading,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<CrossFile?>(
      fieldPath: fieldPath,
      builder: (context, field, file, error) {
        return StyledList.row(
          children: [
            Expanded(
              child: StyledReadonlyTextField(
                text: file?.path,
                labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
                label: label,
                showRequiredIndicator: field.findIsRequired(),
                leadingIcon: leadingIcon,
                leading: leading,
                errorText: error?.toString(),
                hintText: hintText,
                onTapped: enabled
                    ? () async {
                        final allowedFileTypes = this.allowedFileTypes ?? AllowedFileTypes.any;
                        final result = await FilePicker.platform.pickFiles(
                          type: allowedFileTypes.asFileType(),
                          allowedExtensions: allowedFileTypes.getAllowedExtensions(),
                          withData: true,
                        );

                        if (result == null || result.files.isEmpty) {
                          return;
                        }

                        port[fieldPath] = result.files.first.asCrossFile();
                      }
                    : null,
              ),
            ),
            if (file != null)
              StyledButton(
                iconData: Icons.remove_circle,
                onPressed: () {
                  port[fieldPath] = null;
                },
              ),
          ],
        );
      },
    );
  }
}
