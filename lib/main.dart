import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/theme/theme.dart';
import 'package:magspot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:magspot/features/auth/presentation/pages/sign_in.dart';
import 'package:magspot/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await intitDependencies();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
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
