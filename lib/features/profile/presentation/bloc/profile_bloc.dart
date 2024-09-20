import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/features/profile/domain/usecase/user_profile_updation.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  final UserProfileUpdation _userProfileUpdation;
  ProfileBloc(
      {required UserProfileUpdation userProfileUpdation,
      required AppUserCubit appusercubit})
      : _userProfileUpdation = userProfileUpdation,
        _appUserCubit = appusercubit,
        super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) => emit(ProfileLoading()));
    on<ProfileUpdation>(_profileUpdation);
  }

  void _profileUpdation(ProfileUpdation event, Emitter emit) async {
    try {
      final res = await _userProfileUpdation(ProfileUpdationParams(
          id: event.id, name: event.name, bio: event.bio, file: event.file));
      res.fold(
        (l) => emit(ProfileUpdationFailed(error: l.message)),
        (user) => _emitProfileSuccess(user, emit),
      );
    } catch (e) {
      emit(ProfileUpdationFailed(error: e.toString()));
    }
  }

  _emitProfileSuccess(user, emit) {
    _appUserCubit.updateUser(user);
    emit(ProfileUpdateSuccess(user: user));
  }
}
