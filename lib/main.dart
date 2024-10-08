import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/theme/theme.dart';
import 'package:magspot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:magspot/features/auth/presentation/pages/sign_in.dart';
import 'package:magspot/features/magazine/presentation/bloc/comment_bloc/comment_bloc.dart';
import 'package:magspot/features/magazine/presentation/bloc/like_bloc/like_bloc.dart';
import 'package:magspot/features/magazine/presentation/bloc/mag_bloc/mag_bloc_bloc.dart';
import 'package:magspot/features/magazine/presentation/pages/bottom_nav_page.dart';
import 'package:magspot/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:magspot/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await intitDependencies();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AppUserCubit>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<MagBlocBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<ProfileBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<LikeBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<CommentBloc>(),
    )
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Magazine App',
        theme: AppTheme.darkModeTheme,
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return const BottomNavPage();
            }
            return const LoginPage();
          },
        ));
  }
}
