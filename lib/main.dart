import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/lead_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/lead_list_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeadProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mini Lead Manager',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const LeadListScreen(),
          );
        },
      ),
    );
  }
}
