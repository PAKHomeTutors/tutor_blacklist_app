import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'providers/person_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Humne yahan ChangeNotifierProvider ko wrap kar diya hai
  // taake poore app mein database ka data accessible ho sake.
  runApp(
    ChangeNotifierProvider(
      create: (_) => PersonProvider()..loadAllPersons(),
      child: const TutorBlacklistApp(),
    ),
  );
}

class TutorBlacklistApp extends StatelessWidget {
  const TutorBlacklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutor Blacklist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}