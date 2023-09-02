import 'package:flutter/material.dart';

import 'package:grouping_project/View/app/app_view.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 呼叫 theme_manager.dart
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) => MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: themeManager.colorSchemeSeed,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            // 呼叫 home_page.dart
            '/': (context) => const AppView(),
            '/login': (context) => const AuthView(),
            '/signIn': (context) => const AuthView(mode: 'signIn',),
          },
          initialRoute: '/',
          // 呼叫 home_page.dart
          // home: const AppView()
        ),
      ),
    );
  }
}
