import 'package:flutter/material.dart';
import 'package:notes/widgets/notes_screen.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 40, 197, 218));

final kDarkColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 40, 218, 168));

void main() {
  runApp(MaterialApp(
    darkTheme: ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: kDarkColorScheme.primary,
        foregroundColor: kDarkColorScheme.onPrimary,
        titleTextStyle: TextStyle(fontSize: 25) 
      ),
      scaffoldBackgroundColor: kDarkColorScheme.secondary,
      floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
        backgroundColor: kDarkColorScheme.surface,
        foregroundColor: kDarkColorScheme.onSurface
      ),
      bottomSheetTheme: BottomSheetThemeData().copyWith(
        backgroundColor: kDarkColorScheme.secondary
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kDarkColorScheme.onSurfaceVariant,
          foregroundColor: kDarkColorScheme.onPrimary
        )
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: kDarkColorScheme.secondaryContainer,
          foregroundColor: kDarkColorScheme.onSecondaryContainer
        )
      ),
      cardTheme: CardThemeData().copyWith(
        color: kDarkColorScheme.primaryContainer
      ),
    
    ),
    theme: ThemeData().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: kColorScheme.primary,
        foregroundColor: kColorScheme.onPrimary,
        titleTextStyle: TextStyle(fontSize: 25) 
      ),
      scaffoldBackgroundColor: kColorScheme.secondaryContainer,
      floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
        backgroundColor: kColorScheme.surface,
        foregroundColor: kColorScheme.onSurface
      ),
      bottomSheetTheme: BottomSheetThemeData().copyWith(
        backgroundColor: kColorScheme.secondaryContainer
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.onPrimary
        )
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: kColorScheme.secondaryContainer,
          foregroundColor: kColorScheme.onSecondaryContainer
        )
      ),
      cardTheme: CardThemeData().copyWith(
        color: kColorScheme.primaryContainer
      ),
      
     
    ),
    themeMode: ThemeMode.system,
    home: NotesScreen()));
}
