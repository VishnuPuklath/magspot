import 'dart:io';

import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserModel> updateProfileUser(
      String? name, String? bio, String? profilePic);
  Future<void> updateAuthProfileUser(
    String? email,
    String? password,
  );
  Future<String> uploadProfilePic(String userid, File file);
}

class ProfileDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileDataSourceImpl({required this.supabaseClient});
  @override
  Future<UserModel> updateProfileUser(
      String? name, String? bio, String? profilePic) async {
    try {
      final profileUpdates = <String, dynamic>{};
      if (name != null) profileUpdates['name'] = name;
      if (bio != null) profileUpdates['bio'] = bio;
      if (profilePic != null) profileUpdates['profilepic'] = profilePic;

      final response = await supabaseClient
          .from('profiles')
          .update(profileUpdates)
          .eq('id', supabaseClient.auth.currentUser!.id)
          .select()
          .single();

      return UserModel.fromJson(response).copyWith(
          email: supabaseClient.auth.currentUser!.email,
          id: supabaseClient.auth.currentUser!.id);
    } on PostgrestException catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateAuthProfileUser(String? email, String? password) async {
    try {
      final response = await supabaseClient.auth
          .updateUser(UserAttributes(password: password));
    } on PostgrestException catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadProfilePic(String userId, File file) async {
    try {
      await supabaseClient.storage.from('profile_pics').upload(userId, file);
      return supabaseClient.storage.from('profile_pics').getPublicUrl(userId);
    } on PostgrestException catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
