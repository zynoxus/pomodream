import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const PomoDreamApp(),
    ),
  );
}

class PomoDreamApp extends StatelessWidget {
  const PomoDreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context).themeColor;
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'PomoDream',
      theme: ThemeData(
        primaryColor: themeColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: themeColor),
        scaffoldBackgroundColor: const Color(0xFFB2EBF2),
      ),
      home: const HomeScreen(),
    );
  }
}
