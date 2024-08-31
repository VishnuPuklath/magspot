import 'package:get_it/get_it.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/secrets/app_dart.dart';
import 'package:magspot/features/auth/data/datasources/auth_data_remote_data_source.dart';
import 'package:magspot/features/auth/data/repository/auth_repositor_impl.dart';
import 'package:magspot/features/auth/domain/repository/auth_repository.dart';
import 'package:magspot/features/auth/domain/usecases/current_user.dart';
import 'package:magspot/features/auth/domain/usecases/user_login.dart';
import 'package:magspot/features/auth/domain/usecases/user_sign_up.dart';
import 'package:magspot/features/auth/domain/usecases/user_signout.dart';
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
  //core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
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

  serviceLocator.registerFactory(
    () => UserLogin(authRepository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(authRepository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => UserSignout(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
        userSignOut: serviceLocator(),
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator()),
  );
}
