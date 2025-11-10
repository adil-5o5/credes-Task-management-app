import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/onboarding.dart/onboarding_screen.dart';

import 'app_providers.dart';
import 'list/lists_screen.dart';
import 'task/tasks_screen.dart';
import 'search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboard = prefs.getBool('seen_onboard') ?? false;

  final container = ProviderContainer();
  await container.read(dbServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(showOnboarding: !seenOnboard),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Task Management',
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: showOnboarding ? const OnboardingScreen() : const ListsScreen(),
        routes: {
          '/home': (_) => const ListsScreen(),
          '/search': (_) => const SearchScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/tasks') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => TasksScreen(
                listid: args['listId'],
                listtitle: args['listTitle'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
