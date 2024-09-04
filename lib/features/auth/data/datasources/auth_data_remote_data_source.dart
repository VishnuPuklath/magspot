import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataRemoteDataSource {
  Session? get currentUser;
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<UserModel?> getCurrentUser();
  Future<UserModel?> signOut();
}

class AuthDataRemoteDataSourceImpl implements AuthDataRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthDataRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUser => supabaseClient.auth.currentSession;

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

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUser != null) {
        final uid = currentUser!.user.id;

        final userModel =
            await supabaseClient.from('profiles').select().eq('id', uid);
        return UserModel.fromJson(userModel.first)
            .copyWith(email: currentUser!.user.email, id: currentUser!.user.id);
      }

      return null;
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> signOut() async {
    try {
      await supabaseClient.auth.signOut();

      return null;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
