import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/theme/app_theme.dart';

// small drawer: i only added theme switch here, will expand if we need
class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);

    return Drawer(
      backgroundColor: isDark ? Colors.black : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Theme toggle
            ListTile(
              title: Text(
                themeMode == ThemeMode.dark ? 'Light Theme' : 'Dark Theme',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
