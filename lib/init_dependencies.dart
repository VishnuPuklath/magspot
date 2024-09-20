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
import 'package:magspot/features/magazine/data/datasources/remote_data_source.dart';
import 'package:magspot/features/magazine/data/respository/magazine_repository_impl.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';
import 'package:magspot/features/magazine/domain/usecases/get_all_magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/upload_magazine.dart';
import 'package:magspot/features/magazine/presentation/bloc/mag_bloc_bloc.dart';
import 'package:magspot/features/profile/data/datasource/profile_data_source.dart';
import 'package:magspot/features/profile/data/repository/profile_repository_impl.dart';
import 'package:magspot/features/profile/domain/repository/profile_repository.dart';
import 'package:magspot/features/profile/domain/usecase/user_profile_updation.dart';
import 'package:magspot/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> intitDependencies() async {
  _initAuth();
  _initMag();
  _initProfile();
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

void _initMag() {
  serviceLocator
    ..registerFactory<MagazineRemoteDataSource>(
      () => MagazineRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<MagazineRepository>(
      () => MagazineRepositoryImpl(magazineRemoteDataSource: serviceLocator()),
    )
    ..registerFactory(
      () => UploadMagazine(magazineRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetAllMagazine(magazineRepository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => MagBlocBloc(
          getAllMagazine: serviceLocator(), uploadMagazine: serviceLocator()),
    );
}

void _initProfile() {
  serviceLocator
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(profileDataSource: serviceLocator()),
    )
    ..registerFactory(
      () => UserProfileUpdation(profileRepository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => ProfileBloc(
          appusercubit: serviceLocator(),
          userProfileUpdation: serviceLocator()),
    );
}
