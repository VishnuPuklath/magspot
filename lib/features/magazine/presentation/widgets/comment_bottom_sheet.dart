import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:magspot/features/magazine/domain/entities/comment.dart';
import 'package:magspot/features/magazine/presentation/bloc/comment_bloc/comment_bloc.dart';

class CommentBottomSheet extends StatefulWidget {
  final String magazineId;
  final String userId;

  const CommentBottomSheet(
      {super.key, required this.magazineId, required this.userId});
  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial comments and set up real-time subscription
    context.read<CommentBloc>().add(GetCommentsEvent(widget.magazineId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CommentsLoaded) {
          return _buildCommentsUI(state.comments);
        } else if (state is CommentError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No comments found.'));
        }
      },
    );
  }

  Widget _buildCommentsUI(List<Comment> comments) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Comments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final date = DateFormat('dd-MM-yyyy').format(comment.createdAt);
                final time = DateFormat('hh:mm a').format(comment.createdAt);

                return ListTile(
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(date),
                      Text(time),
                    ],
                  ),
                  title:
                      Text(comment.userName), // Assuming Comment has userName
                  subtitle:
                      Text(comment.commentText), // Assuming Comment has text
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      context.read<CommentBloc>().add(
                            AddCommentEvent(
                              magazineId: widget.magazineId,
                              userId: widget.userId, // Provide userId
                              commentText: _commentController.text,
                            ),
                          );
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
