import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/common/widgets/loader.dart';
import 'package:magspot/core/utils/show_snack_bar.dart';

import 'package:magspot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:magspot/features/auth/presentation/pages/sign_in.dart';
import 'package:magspot/features/magazine/presentation/bloc/mag_bloc_bloc.dart';
import 'package:magspot/features/magazine/presentation/pages/magazine_detail_page.dart';
import 'package:magspot/features/magazine/presentation/widgets/mag_card.dart';

class MagazinePage extends StatefulWidget {
  const MagazinePage({super.key});

  @override
  State<MagazinePage> createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  @override
  void initState() {
    super.initState();
    context.read<MagBlocBloc>().add(MagazineGetAllEvent());
  }

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
      body: BlocConsumer<MagBlocBloc, MagBlocState>(
        listener: (context, state) {
          if (state is MagBlocFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is MagBlocLoading) {
            return const Loader();
          }
          if (state is MagFetchAllSuccess) {
            return ListView.builder(
              itemCount: state.magazines.length,
              itemBuilder: (context, index) {
                final magazine = state.magazines[index];
                context
                    .read<MagBlocBloc>()
                    .add(SubscribeToLikesEvent(magazineId: magazine.id));
                print(magazine.posterId);
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MagazineDetailPage(
                              magazine: magazine,
                            ),
                          ));
                    },
                    child: MagCard(magazine: magazine));
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
