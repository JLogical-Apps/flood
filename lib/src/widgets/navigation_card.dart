import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Card that shows navigation.
class NavigationCard extends StatelessWidget {
  /// The title of the navigation card.
  final Widget title;

  /// The description for the navigation card.
  final Widget? description;

  /// The icon to show in front.
  final Widget? icon;

  /// The color for the navigation card. If [null], then uses primary theme.
  final Color? color;

  /// Whether the [color] should fill the navigation card or simply be an accent.
  final bool fillColor;

  /// Action to perform when tapped.
  VoidCallback? onTap;

  /// Whether the link is external. This will render the trailing icon differently.
  final bool isExternalLink;

  /// The margin of the card.
  final EdgeInsets? margin;

  NavigationCard({
    Key? key,
    required this.title,
    required this.onTap,
    this.description,
    this.icon,
    this.color,
    this.fillColor: false,
    this.isExternalLink: false,
    this.margin,
  }) : super(key: key);

  /// Creates a navigation card to open up the given [url].
  NavigationCard.url({
    Key? key,
    required this.title,
    required String url,
    this.description,
    this.icon,
    this.color,
    this.fillColor: false,
    this.isExternalLink: true,
    this.margin,
  }) : super(key: key) {
    onTap = () async {
      if (await canLaunch(url)) {
        launch(url);
      }
    };
  }

  Color _getBackgroundColor(BuildContext context) {
    if (fillColor) {
      return color ?? Theme.of(context).primaryColor;
    } else {
      return Colors.white;
    }
  }

  Color _getIconColor(BuildContext context) {
    if (fillColor) {
      return useWhiteForeground(_getBackgroundColor(context))
          ? Theme.of(context).primaryIconTheme.color!
          : Theme.of(context).iconTheme.color!;
    } else {
      return color ?? Theme.of(context).primaryColor;
    }
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    if (fillColor) {
      return useWhiteForeground(_getBackgroundColor(context))
          ? Theme.of(context).primaryTextTheme.subtitle1!
          : Theme.of(context).textTheme.subtitle1!;
    } else {
      return Theme.of(context).textTheme.subtitle1!.copyWith(color: color ?? Theme.of(context).primaryColor);
    }
  }

  TextStyle _getSubtitleTextStyle(BuildContext context) {
    if (fillColor) {
      return useWhiteForeground(_getBackgroundColor(context))
          ? Theme.of(context).primaryTextTheme.bodyText2!
          : Theme.of(context).textTheme.bodyText2!;
    } else {
      return Theme.of(context).textTheme.bodyText2!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getBackgroundColor(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: DefaultTextStyle(
            child: title,
            style: _getTitleTextStyle(context),
          ),
          subtitle: description == null
              ? null
              : DefaultTextStyle(
                  child: description!,
                  style: _getSubtitleTextStyle(context),
                ),
          leading: icon == null
              ? null
              : IconTheme(
                  child: icon!,
                  data: IconThemeData(color: _getIconColor(context)),
                ),
          trailing: isExternalLink
              ? Icon(
                  Icons.exit_to_app,
                  color: _getIconColor(context),
                )
              : Icon(
                  Icons.chevron_right,
                  color: _getIconColor(context),
                ),
        ),
        onTap: onTap,
      ),
      margin: margin,
    );
  }
}

bool useWhiteForeground(Color color) {
  return color.computeLuminance() < 0.5;
}
