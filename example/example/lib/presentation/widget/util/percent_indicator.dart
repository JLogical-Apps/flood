import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PercentIndicator extends StatelessWidget {
  final Color? backgroundColor;
  final Map<double, Color> percentToColorMap;
  final double height;

  const PercentIndicator({
    super.key,
    this.backgroundColor,
    required this.percentToColorMap,
    this.height = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorPalette().background.subtle,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: percentToColorMap
            .mapToIterable((percent, color) => Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: percent,
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
