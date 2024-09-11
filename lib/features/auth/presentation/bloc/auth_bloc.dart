import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/features/auth/domain/usecases/current_user.dart';
import 'package:magspot/features/auth/domain/usecases/user_login.dart';
import 'package:magspot/features/auth/domain/usecases/user_sign_up.dart';
import 'package:magspot/features/auth/domain/usecases/user_signout.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserSignout _userSignout;
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit,
      required UserSignout userSignOut})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userSignout = userSignOut,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthUserSIgnout>(_onUserSignOut);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter emit) {
    (event, emit) async {
      final res = await _userSignUp(
        UserSignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
      res.fold((l) => emit(AuthFailure(message: l.message)),
          (user) => _authEmitSuccess(user, emit));
    };
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold((l) => AuthFailure(message: l.message), (user) {
      print('on login');
      print(user.email);
      print(user.id);
      _authEmitSuccess(user, emit);
    });
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold((l) {
      print(l.message);
      emit(AuthFailure(message: l.message));
    }, (user) => _authEmitSuccess(user, emit));
  }

  void _authEmitSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }

  void _onUserSignOut(AuthUserSIgnout event, Emitter<AuthState> emit) async {
    print('signout');
    final res = await _userSignout(NoParams());
    res.fold((l) {
      emit(AuthFailure(message: l.message));
    }, (user) {
      if (user == null) {
        _appUserCubit.updateUser(user);
        emit(AuthInitial());
      }
    });
  }
}
