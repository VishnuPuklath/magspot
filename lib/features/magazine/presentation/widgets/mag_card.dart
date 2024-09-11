import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';

import 'package:magspot/features/magazine/domain/entities/magazine.dart';

class MagCard extends StatelessWidget {
  final Magazine magazine;
  const MagCard({
    Key? key,
    required this.magazine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state as AppUserLoggedIn;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 116, 169, 185),
          borderRadius: BorderRadius.circular(10)),
      height: 350,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.istockphoto.com/id/1462151715/photo/portrait-of-a-senior-woman-breathing-fresh-air.webp?a=1&b=1&s=612x612&w=0&k=20&c=shxQMiUI0RNnLx_d5ZikY511jXAOwA6BOPcmzYPJbjk='),
            ),
            title: Text(
              state.user.id == magazine.posterId ? 'You' : magazine.posterName!,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: Image.network(fit: BoxFit.cover, magazine.thumbnail),
          ),
          ListTile(
            leading: Text(
              'Magazine Name',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
