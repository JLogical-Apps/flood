import 'package:drop/src/sync_hooks.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class SyncIndicator extends HookWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final syncState = useSyncState();

    return switch (syncState) {
      SyncState.none => Container(),
      SyncState.syncing => StyledLoadingIndicator(),
      SyncState.syncingTooLong => StyledButton(
          iconData: Icons.cloud_off,
          onPressed: () async {
            await context.showStyledDialog(StyledDialog(
              titleText: 'Poor Internet Connection',
              body: StyledList.column(
                children: [
                  StyledText.body('Synchronizing the data took too long. Try again when you have better internet.'),
                  StyledCard(
                    titleText: 'Try Sync Again',
                    bodyText:
                        'Once you are connected to the internet, use this to attempt to re-sync your local changes to the cloud.',
                    leadingIcon: Icons.refresh,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      context.corePondContext.syncCoreComponent.publish();
                    },
                  ),
                ],
              ),
            ));
          },
        ),
      SyncState.error => StyledButton(
          iconData: Icons.error,
          onPressed: () async {
            await context.showStyledDialog(StyledDialog(
              titleText: 'Error Syncing Data',
              body: StyledList.column(
                children: [
                  StyledText.body(
                    "There was an error syncing data. Ensure you are connected to the internet. If that doesn't work, try one of the following actions to fix the issue.",
                  ),
                  StyledCard(
                    titleText: 'Try Sync Again',
                    bodyText:
                        'Once you are connected to the internet, use this to attempt to re-sync your local changes to the cloud.',
                    leadingIcon: Icons.refresh,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      context.corePondContext.syncCoreComponent.publish();
                    },
                  ),
                  StyledCard(
                    title: StyledText.lg.bold.display.withColor(Colors.red)('Clear Local Changes'),
                    bodyText:
                        'If you are connected to the internet and you believe your data is corrupted, use this to clear your local changes. Beware, you will lose any unsaved progress!',
                    leading: StyledIcon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await context.showStyledDialog(StyledDialog.yesNo(
                        titleText: 'Confirm Delete Local Changes',
                        bodyText: 'Are you sure you want to delete your local changes? You cannot undo this.',
                        onAccept: () async {
                          Navigator.of(context).pop();
                          await context.corePondContext.syncCoreComponent.deleteChanges();
                          context.showStyledMessage(StyledMessage(
                            labelText: 'Your local changes have been deleted. Restart your app to get the latest data.',
                          ));
                        },
                      ));
                    },
                  ),
                ],
              ),
            ));
          },
        ),
      SyncState.synced => StyledIcon(Icons.cloud_done),
    };
  }
}
