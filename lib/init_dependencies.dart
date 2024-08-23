import 'package:get_it/get_it.dart';
import 'package:magspot/core/secrets/app_dart.dart';
import 'package:magspot/features/auth/data/datasources/auth_data_remote_data_source.dart';
import 'package:magspot/features/auth/data/repository/auth_repositor_impl.dart';
import 'package:magspot/features/auth/domain/repository/auth_repository.dart';
import 'package:magspot/features/auth/domain/usecases/user_sign_up.dart';
import 'package:magspot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> intitDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.annonKey);
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthDataRemoteDataSource>(
    () => AuthDataRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositorImpl(remoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(userSignUp: serviceLocator()),
  );
}
