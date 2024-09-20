import 'package:flutter/material.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MagazineDetailPage extends StatelessWidget {
  final Magazine magazine;
  const MagazineDetailPage({super.key, required this.magazine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(magazine.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 700,
                child: SfPdfViewer.network(magazine.file),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
