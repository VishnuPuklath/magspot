import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/presentation/bloc/mag_bloc_bloc.dart';

class MagCard extends StatelessWidget {
  final Magazine magazine;
  const MagCard({
    Key? key,
    required this.magazine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state as AppUserLoggedIn;
    final userId = state.user.id;

    return BlocBuilder<MagBlocBloc, MagBlocState>(builder: (context, magState) {
      bool isLiked = magazine.likes!.contains(userId);
      int totalLikes = magazine.likes!.length;

      if (magState is MagazineLikesUpdated && magState.likes.isNotEmpty) {
        totalLikes = magState.likes.length;
        isLiked = magState.likes.contains(userId);
      }

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), // Semi-transparent background
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/id/1462151715/photo/portrait-of-a-senior-woman-breathing-fresh-air.webp?a=1&b=1&s=612x612&w=0&k=20&c=shxQMiUI0RNnLx_d5ZikY511jXAOwA6BOPcmzYPJbjk='),
                  ),
                  title: Text(
                    userId == magazine.posterId ? 'You' : magazine.posterName!,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(fit: BoxFit.cover, magazine.thumbnail),
                ),
                Text(
                  'Magazine name: ${magazine.name}',
                  style: const TextStyle(color: Colors.black),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              context.read<MagBlocBloc>().add(
                                    LikeMagazine(
                                        magazineId: magazine.id,
                                        userId: userId),
                                  );
                            },
                            icon: isLiked
                                ? const Icon(Icons.favorite, color: Colors.red)
                                : const Icon(Icons.favorite_outline)),
                        Text(
                          '$totalLikes',
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.comment_sharp),
                        ),
                        const Text(
                          '0',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
