import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/common/widgets/loader.dart';
import 'package:magspot/core/utils/show_snack_bar.dart';
import 'package:magspot/features/magazine/presentation/bloc/mag_bloc_bloc.dart';
import 'package:magspot/features/magazine/presentation/pages/bottom_nav_page.dart';
import 'package:magspot/core/common/widgets/mag_button.dart';
import 'package:magspot/core/common/widgets/mag_textform.dart';

class MagazineAddPage extends StatefulWidget {
  const MagazineAddPage({super.key});

  @override
  State<MagazineAddPage> createState() => _MagazineAddPageState();
}

class _MagazineAddPageState extends State<MagazineAddPage> {
  late final String posterId;
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  File? _selectedPdf;
  File? _selectedThumbnail;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf'],
      );
      print(result);
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedPdf = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print('Error picking PDF: ${e.toString()}');
    }
  }

  Future<void> _pickThumbnail() async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ]);
      if (result != null) {
        setState(() {
          _selectedThumbnail = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print('Error while picking thumbnail: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Magazine'),
      ),
      body: BlocConsumer<MagBlocBloc, MagBlocState>(
        listener: (context, state) {
          if (state is MagBlocFailure) {
            showSnackBar(context, state.error);
          }
          if (state is MagBlocSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavPage(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is MagBlocLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickThumbnail,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        color: Colors.white,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          alignment: Alignment.center,
                          child: _selectedThumbnail == null
                              ? const Text('Add your magazine thumbnail')
                              : SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Image.file(
                                    _selectedThumbnail!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: _pickPdf,
                      child: _selectedPdf != null
                          ? Text(
                              _selectedPdf!.path,
                              textAlign: TextAlign.center,
                            )
                          : Column(
                              children: [
                                TextButton(
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    size: 50,
                                  ),
                                  onPressed: () {},
                                ),
                                const Text('Upload magazine')
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MagTextform(
                      hintText: 'Enter Magazine Name',
                      controller: _nameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MagTextform(
                      hintText: 'Enter Author Name',
                      controller: _authorController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MagTextform(
                      hintText: 'Enter Magazine Description',
                      controller: _descriptionController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MagButton(
                        buttonText: 'Upload',
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedPdf != null &&
                              _selectedThumbnail != null) {
                            final posterId = (context.read<AppUserCubit>().state
                                    as AppUserLoggedIn)
                                .user
                                .id;
                            print('poster id is $posterId');
                            context.read<MagBlocBloc>().add(MagazineUpload(
                                thumbnail: _selectedThumbnail!,
                                posterId: posterId,
                                name: _nameController.text.trim(),
                                authorname: _authorController.text.trim(),
                                description: _descriptionController.text.trim(),
                                file: _selectedPdf!));
                            print('upload button executed');
                          }
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
