import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/common/widgets/mag_button.dart';
import 'package:magspot/core/common/widgets/mag_textform.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/core/utils/show_snack_bar.dart';
import 'package:magspot/features/magazine/presentation/pages/bottom_nav_page.dart';
import 'package:magspot/features/profile/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  late User user;
  late String initialName;
  late String initialBio;
  late String initialProfilePic;
  String? newProfilePic;
  File? pickedImageFile;
  @override
  void initState() {
    super.initState();
    initialTask();
  }

  initialTask() {
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

    setState(() {
      _nameController.text = user.name;
      _bioController.text = user.bio ?? '';
      initialName = user.name ?? '';
      initialBio = user.bio ?? '';
      initialProfilePic = user.profilePic ?? "";
      newProfilePic = initialProfilePic;
    });
  }

  void _saveChanges() async {
    final name = _nameController.text;
    final bio = _bioController.text;

    final bool nameChanged = name != initialName;
    final bool bioChanged = bio != initialBio;
    final bool profilePicChanged =
        initialProfilePic != newProfilePic || pickedImageFile != null;
    ;

    if (profilePicChanged || nameChanged || bioChanged) {
      context.read<ProfileBloc>().add(ProfileUpdation(
          id: user.id,
          name: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          file: pickedImageFile));
    } else {
      showSnackBar(context, 'No Changes Detected');
    }
  }

  Future<void> _pickProfilePic() async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ]);
      if (result != null) {
        setState(() {
          pickedImageFile = File(result.files.single.path!);
          newProfilePic = null;
        });
      }
    } catch (e) {
      print('Error while picking thumbnail: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            showSnackBar(context, 'Profile Updated Successfully');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavPage(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: pickedImageFile != null
                              ? FileImage(pickedImageFile!)
                              : (newProfilePic!.isEmpty
                                  ? const NetworkImage(
                                      'https://images.unsplash.com/photo-1581391528803-54be77ce23e3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2ZpbGUlMjBwaWN8ZW58MHx8MHx8fDA%3D', // Default image
                                    )
                                  : NetworkImage(newProfilePic!)
                                      as ImageProvider),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton(
                            onPressed: () {
                              _pickProfilePic();
                            },
                            icon: const Icon(Icons.add_a_photo),
                            color: Colors.white,
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                    MagTextform(hintText: 'Name', controller: _nameController),
                    MagTextform(
                        hintText: 'Bio',
                        controller: _bioController,
                        maxLines: 3),
                    const SizedBox(
                      height: 30,
                    ),
                    MagButton(
                        buttonText: 'Save Changes',
                        onPressed: () {
                          _saveChanges();
                        })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
