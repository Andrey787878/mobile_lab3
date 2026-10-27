import 'package:flutter/material.dart';

import 'screens/todo_screen.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = Colors.amber.shade700;
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мои задачи',
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: accent,
          secondary: accent,
          surface: Colors.grey.shade900,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 64,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade900,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.all(18),
          border: fieldBorder,
          enabledBorder: fieldBorder,
          focusedBorder: fieldBorder.copyWith(
            borderSide: BorderSide(color: accent),
          ),
          errorBorder: fieldBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFFEF9A9A)),
          ),
          focusedErrorBorder: fieldBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFFEF9A9A)),
          ),
          errorMaxLines: 2,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 56),
            textStyle: const TextStyle(fontSize: 18),
            shape: const StadiumBorder(),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 0,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected) ? accent : null;
          }),
          checkColor: const WidgetStatePropertyAll(Colors.white),
          side: const BorderSide(color: Colors.grey, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      builder: (context, child) =>
          ColoredBox(color: Colors.black, child: child!),
      home: const TodoScreen(),
    );
  }
}
