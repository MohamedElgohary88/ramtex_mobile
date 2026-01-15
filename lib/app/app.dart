import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

/// Root Application Widget
/// 
/// Configures:
/// - Theme (Material 3)
/// - Router (GoRouter)
/// - Future: Localizations, BlocProviders
class RamtexApp extends StatelessWidget {
  const RamtexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ramtex',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      // TODO: Add dark theme support
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
      
      // Router Configuration
      routerConfig: AppRouter.instance.router,
      
      // Builder for global overlays (loading, etc.)
      builder: (context, child) {
        return MediaQuery(
          // Prevent text scaling beyond reasonable limits
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
