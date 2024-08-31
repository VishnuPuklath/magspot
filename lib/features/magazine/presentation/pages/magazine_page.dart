import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';

import 'package:magspot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:magspot/features/auth/presentation/pages/sign_in.dart';

class MagazinePage extends StatelessWidget {
  const MagazinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              }
            },
            child: IconButton(
              onPressed: () {
                context.read<AppUserCubit>().updateUser(null);
                context.read<AuthBloc>().add(AuthUserSIgnout());
              },
              icon: const Icon(Icons.logout),
            ),
          )
        ],
        title: const Text(
          'Magazine',
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Magpage'),
      ),
    );
  }
}
