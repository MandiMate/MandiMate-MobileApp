import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MandiMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryGreen,
          secondary: AppTheme.lightGreen,
          surface: AppTheme.white,
          background: AppTheme.lightGrey,
          error: Colors.red,
        ),
        textTheme: AppTheme.textTheme,
        elevatedButtonTheme: AppTheme.elevatedButtonTheme,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
