import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/secrets/app_dart.dart';
import 'package:magspot/core/theme/theme.dart';
import 'package:magspot/features/auth/data/datasources/auth_data_remote_data_source.dart';
import 'package:magspot/features/auth/data/repository/auth_repositor_impl.dart';
import 'package:magspot/features/auth/domain/usecases/user_sign_up.dart';
import 'package:magspot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:magspot/features/auth/presentation/pages/sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.annonKey);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => AuthBloc(
          userSignUp: UserSignUp(
              authRepository: AuthRepositorImpl(
                  remoteDataSource: AuthDataRemoteDataSourceImpl(
                      supabaseClient: supabase.client)))),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Magazine App',
        theme: AppTheme.darkModeTheme,
        home: const LoginPage());
  }
}
