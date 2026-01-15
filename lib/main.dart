import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/router.dart';
import 'core/di/injection_container.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for mobile)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependencies
  await initializeDependencies();

  // Check initial auth state
  final authRepository = getIt<AuthRepository>();
  final user = await authRepository.getCurrentUser();
  final String initialRoute = (user != null && user.isAuthenticated)
      ? AppRouter.homePath
      : AppRouter.loginPath;

  // Run the app
  runApp(RamtexApp(initialRoute: initialRoute));
}
