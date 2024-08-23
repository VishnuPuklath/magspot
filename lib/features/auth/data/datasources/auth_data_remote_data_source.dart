import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataRemoteDataSource {
  Future<String> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<String> loginWithEmailAndPassword(
      {required String email, required String password});
}

class AuthDataRemoteDataSourceImpl implements AuthDataRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthDataRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailAndPassword({
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
      return response.user!.id;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
