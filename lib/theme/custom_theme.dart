import 'package:flutter/material.dart';
import './palette.dart';

class CustomTheme {
  static ThemeData darkTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(Palette.yellow500.value, const {500: Palette.yellow500}),
          accentColor: Palette.yellow500,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Palette.almostBlack,
        appBarTheme: const AppBarTheme(elevation: 0, color: Palette.almostBlack),
        textTheme: theme.primaryTextTheme
            .copyWith(
                button: theme.primaryTextTheme.button?.copyWith(
              color: Palette.yellow500,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ))
            .apply(displayColor: Palette.yellow500),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          backgroundColor: Palette.yellow500,
        )));
  }
}
