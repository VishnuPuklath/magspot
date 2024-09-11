import 'dart:io';

import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/features/magazine/data/models/magazine_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MagazineRemoteDataSource {
  Future<MagazineModel> uploadMagazine(MagazineModel magazine);
  Future<String> uploadMagazinePdf(
      {required File file, required MagazineModel magazineModel});

  Future<String> uploadThumbnail(
      {required File file, required MagazineModel magazineModel});
  Future<List<MagazineModel>> getMagazine();
}

class MagazineRemoteDataSourceImpl implements MagazineRemoteDataSource {
  final SupabaseClient supabaseClient;

  MagazineRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<MagazineModel> uploadMagazine(MagazineModel magazine) async {
    try {
      Map<String, dynamic> map = magazine.toMap();
      print('map is$map');
      final magData = await supabaseClient
          .from('magazine')
          .insert(magazine.toMap())
          .select();
      return MagazineModel.fromMap(magData.first);
    } on PostgrestException catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    } catch (e) {
      print(e.toString());
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
    } on PostgrestException catch (e) {
      print(e.toString());
      throw ServerException(message: e.message);
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MagazineModel>> getMagazine() async {
    try {
      final magazines =
          await supabaseClient.from('magazine').select('*,profiles(name)');

      return magazines
          .map(
            (magazine) => MagazineModel.fromMap(magazine)
                .copyWith(posterName: magazine['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadThumbnail(
      {required File file, required MagazineModel magazineModel}) async {
    try {
      await supabaseClient.storage
          .from('magazine_thumbnails')
          .upload(magazineModel.id, file);
      return supabaseClient.storage
          .from('magazine_thumbnails')
          .getPublicUrl(magazineModel.id);
    } on PostgrestException catch (e) {
      print(e.toString());
      throw ServerException(message: e.message);
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
