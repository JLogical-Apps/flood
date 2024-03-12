import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledFilePortField extends HookWidget {
  final String fieldName;

  final AllowedFileTypes? allowedFileTypes;

  final String? labelText;
  final Widget? label;
  final String? hintText;

  final Widget? leading;
  final IconData? leadingIcon;

  final bool enabled;

  const StyledFilePortField({
    super.key,
    required this.fieldName,
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
      fieldName: fieldName,
      builder: (context, field, file, error) {
        return StyledList.row(
          children: [
            Expanded(
              child: StyledReadonlyTextField(
                text: file?.path,
                labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
                label: label,
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

                        port[fieldName] = result.files.first.asCrossFile();
                      }
                    : null,
              ),
            ),
            if (file != null)
              StyledButton(
                iconData: Icons.remove_circle,
                onPressed: () {
                  port[fieldName] = null;
                },
              ),
          ],
        );
      },
    );
  }
}

extension on PlatformFile {
  CrossFile asCrossFile() {
    final bytes = this.bytes ?? Uint8List(0);
    return CrossFile.static.fromBytes(path: name, bytesGetter: () => bytes);
  }
}

extension on AllowedFileTypes {
  FileType asFileType() {
    if (this is ImageAllowedFileTypes) {
      return FileType.image;
    } else if (this is VideoAllowedFileTypes) {
      return FileType.video;
    } else if (this is AudioAllowedFileTypes) {
      return FileType.audio;
    } else if (this is CustomAllowedFileTypes) {
      return FileType.custom;
    } else {
      return FileType.any;
    }
  }

  List<String>? getAllowedExtensions() {
    if (this is CustomAllowedFileTypes) {
      return (this as CustomAllowedFileTypes).allowedFileTypes;
    } else {
      return null;
    }
  }
}
