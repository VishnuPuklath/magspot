import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/presentation/bloc/comment_bloc/comment_bloc.dart';
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
    final state = context.read<AppUserCubit>().state as AppUserLoggedIn;
    final userId = state.user.id;

    // Load initial comment count when the widget is built
    context.read<CommentBloc>().add(LoadInitialCommentCountEvent(magazine.id));

    return BlocBuilder<LikeBloc, LikeState>(
      buildWhen: (previous, current) {
        return current is LikeUpdatedState;
      },
      builder: (context, likeState) {
        bool isLiked = magazine.likes!.contains(userId);
        int totalLikes = magazine.likes!.length;

        if (likeState is LikeUpdatedState &&
            likeState.magazineId == magazine.id) {
          totalLikes = likeState.likes.length;
          isLiked = likeState.likes.contains(userId);
        }

        return BlocBuilder<CommentBloc, CommentState>(
          builder: (context, commentState) {
            // Default comment count from the magazine data
            int commentCount = magazine.comments?.length ?? 0;

            // Update the comment count based on the bloc's state
            if (commentState is CommentsCountLoaded &&
                commentState.magazineId == magazine.id) {
              commentCount = commentState.count;
            } else if (commentState is CommentsLoaded &&
                commentState.comments.isNotEmpty) {
              commentCount = commentState.comments
                  .length; // Adjust comment count based on loaded comments
            }

            return Visibility(
              visible: true,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    border: Border.all(color: Colors.white.withOpacity(0.9)),
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
                              'https://media.istockphoto.com/id/521977679/photo/silhouette-of-adult-woman.jpg?s=2048x2048&w=is&k=20&c=tFUVwJYHbn57gt6d_aYQJjn5etSuq0SGZe8oKxRLffA=',
                            ),
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
                                    context.read<LikeBloc>().add(
                                          LikeMagazineEvent(
                                            magazineId: magazine.id,
                                            userId: userId,
                                          ),
                                        );
                                  },
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                ),
                                Text(
                                  '$totalLikes Likes',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showCommentsBottomSheet(
                                        context, magazine.id, userId);
                                  },
                                  icon: const Icon(Icons.comment),
                                ),
                                Text(
                                  '$commentCount Comments',
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
      },
    );
  }

  void _showCommentsBottomSheet(
      BuildContext context, String magazineId, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: CommentBottomSheet(
            userId: userId,
            magazineId: magazineId,
          ),
        );
      },
    ).then((_) {
      // Refresh the comment count after the bottom sheet is closed
      context.read<CommentBloc>().add(GetCommentsEvent(magazineId));
    });
  }
}
