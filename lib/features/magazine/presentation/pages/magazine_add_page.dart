import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:magspot/features/magazine/presentation/widgets/mag_textform.dart';

class MagazineAddPage extends StatefulWidget {
  const MagazineAddPage({super.key});

  @override
  State<MagazineAddPage> createState() => _MagazineAddPageState();
}

class _MagazineAddPageState extends State<MagazineAddPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Magazine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              color: Colors.white,
              strokeWidth: 2,
              dashPattern: [8, 4], // Length of the dots and spaces
              child: Container(
                  width: double.infinity,
                  height: 200,
                  alignment: Alignment.center,
                  child:const Icon(Icons.photo)),
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
              hintText: 'Enter Magazine Description',
              controller: _descriptionController,
            ),
          ],
        ),
      ),
    );
  }
}
