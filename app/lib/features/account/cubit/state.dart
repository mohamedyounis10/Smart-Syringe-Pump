import '../../../models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final AppUser user;
  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final AppUser user;
  ProfileUpdated(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileAddressEmpty extends ProfileState {}

class ProfileAddressError extends ProfileState {
  final String message;
  ProfileAddressError(this.message);
}

class ChangePage extends ProfileState {}

class ToggleNewPasswordVisibilityState extends ProfileState {
  final bool isObscure;
  ToggleNewPasswordVisibilityState(this.isObscure);
}

class ProfilePasswordChangedSuccess extends ProfileState {}

class ProfilePasswordChangeError extends ProfileState {
  final String error;
  ProfilePasswordChangeError(this.error);
}
