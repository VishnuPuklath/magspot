import 'dart:io';

import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/features/magazine/data/models/magazine_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MagazineRemoteDataSource {
  Future<MagazineModel> uploadMagazine(MagazineModel magazine);
  Future<String> uploadMagazinePdf(
      {required File file, required MagazineModel magazineModel});
}

class MagazineRemoteDataSourceImpl implements MagazineRemoteDataSource {
  final SupabaseClient supabaseClient;

  MagazineRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<MagazineModel> uploadMagazine(MagazineModel magazine) async {
    try {
      final magData = await supabaseClient
          .from('magazine')
          .insert(magazine.toMap())
          .select();
      return MagazineModel.fromMap(magData.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadMagazinePdf(
      {required File file, required MagazineModel magazineModel}) async {
    try {
      await supabaseClient.storage
          .from('magazine_pdf')
          .upload(magazineModel.id, file);
      return supabaseClient.storage
          .from('magazine_pdf')
          .getPublicUrl(magazineModel.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
