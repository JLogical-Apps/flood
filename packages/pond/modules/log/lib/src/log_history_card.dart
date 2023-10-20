import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:log_core/log_core.dart';
import 'package:model/model.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class LogHistoryCard extends HookWidget {
  final LogHistory history;
  final bool isSelected;
  final Function() onPressed;

  const LogHistoryCard({
    super.key,
    required this.history,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final timeCreatedModel = useFutureModel(() => history.getTimeCreated());

    return ModelBuilder(
      model: timeCreatedModel,
      builder: (DateTime timeCreated) {
        return StyledChip(
          labelText: timeCreated.format(),
          onPressed: onPressed,
          emphasis: isSelected ? Emphasis.strong : Emphasis.regular,
        );
      },
    );
  }
}
