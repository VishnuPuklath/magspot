import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/presentation/bloc/like_bloc/like_bloc.dart';
import 'package:magspot/features/magazine/presentation/widgets/comment_bottom_sheet.dart';

class MagCard extends StatelessWidget {
  final Magazine magazine;

  const MagCard({
    Key? key,
    required this.magazine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('buildno build');
    // Get the user ID from AppUserCubit
    final state = context.read<AppUserCubit>().state as AppUserLoggedIn;
    final userId = state.user.id;

    // Subscribe to like updates using LikeBloc
    return BlocBuilder<LikeBloc, LikeState>(
      buildWhen: (previous, current) {
        // Rebuild when the like state changes for this magazine
        return current is LikeUpdatedState;
      },
      builder: (context, likeState) {
        // Default values
        bool isLiked = magazine.likes!.contains(userId);
        int totalLikes = magazine.likes!.length;
        int magazineCount = magazine.comments!.length;
        // Update like status and count based on LikeUpdatedState
        if (likeState is LikeUpdatedState) {
          totalLikes = likeState.likes.length;
          isLiked = likeState.likes.contains(userId);
        }

        return Visibility(
          visible: true, // Ensure visibility is true here
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
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
                        userId == magazine.posterId
                            ? 'You'
                            : magazine.posterName!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(
                        magazine.thumbnail,
                        fit: BoxFit.cover,
                      ),
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
                                // Dispatch like event to LikeBloc
                                context.read<LikeBloc>().add(
                                      LikeMagazineEvent(
                                        magazineId: magazine.id,
                                        userId: userId,
                                      ),
                                    );
                              },
                              icon: isLiked
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                  : const Icon(Icons.favorite_outline),
                            ),
                            Text(
                              '$totalLikes',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _showCommentsBottomSheet(
                                    context, magazine.id, userId);
                              },
                              icon: const Icon(Icons.comment_sharp),
                            ),
                            Text(
                              magazineCount.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCommentsBottomSheet(
      BuildContext context, String magazineId, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // allows the bottom sheet to cover more space
      builder: (context) {
        return Padding(
          padding:
              MediaQuery.of(context).viewInsets, // To avoid keyboard overlap
          child: CommentBottomSheet(
            userId: userId,
            magazineId: magazineId,
          ),
        );
      },
    );
  }
}
