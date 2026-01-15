/// Auth Feature Barrel File
/// 
/// Exports all auth-related components:
/// - Data layer (repositories, models, datasources)
/// - Domain layer (entities, usecases)
/// - Presentation layer (screens, widgets, cubits)
library;

// Domain Layer
export 'domain/entities/user_entity.dart';
export 'domain/params/auth_params.dart';
export 'domain/repositories/auth_repository.dart';

// Data Layer
export 'data/models/user_model.dart';
export 'data/datasources/auth_remote_datasource.dart';
export 'data/repositories/auth_repository_impl.dart';

// Presentation Layer
export 'presentation/cubit/auth_cubit.dart';
export 'presentation/cubit/auth_state.dart';
export 'presentation/screens/login_screen.dart';
export 'presentation/screens/register_screen.dart';
