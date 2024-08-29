import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password});
}

class AuthDataRemoteDataSourceImpl implements AuthDataRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthDataRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) {
        throw ServerException(message: 'User is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {'name': name});

      if (response.user == null) {
        throw ServerException(message: 'User is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
