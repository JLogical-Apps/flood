import 'package:flutter/material.dart';

class CustomTheme {
  /// Returns the theme used in JLogical apps.
  static ThemeData theme({Color primaryColor, Color accentColor}) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      accentColor: accentColor,
      fontFamily: 'Roboto',
      backgroundColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      appBarTheme: AppBarTheme(
        elevation: 0,
      ),
      buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.spaceEvenly,
        buttonPadding: EdgeInsets.all(4),
        layoutBehavior: ButtonBarLayoutBehavior.padded,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        margin: EdgeInsets.all(8),
        color: Colors.white,
      ),
      cursorColor: primaryColor,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
        ),
        elevation: 24,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black12,
        space: 12,
        indent: 12,
        endIndent: 12,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
      focusColor: primaryColor,
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
        errorMaxLines: 3,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black87),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        elevation: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 12,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
