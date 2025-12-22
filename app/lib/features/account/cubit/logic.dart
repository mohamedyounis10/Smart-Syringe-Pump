import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dose/features/account/cubit/state.dart';
import '../../../core/db/firebase.dart';

class ProfileCubit extends Cubit<ProfileState> {
  // Variables
  final FirebaseService firebaseService;
  bool isObscure1 = true;
  bool isObscure2 = true;
  bool isObscure3 = true;

  ProfileCubit()
      : firebaseService = FirebaseService(),
        super(ProfileInitial()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    emit(ProfileLoading());
    try {
      final user = await firebaseService.getCurrentUserData();
      if (user == null) throw Exception("User not logged in or data not found");
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(ProfileLoading());
    try {
      await firebaseService.updateUserData({
        "name": name,
        "email": email,
        "phoneNumber": phone,
      });
      final updatedUser = await firebaseService.getCurrentUserData();
      emit(ProfileLoaded(updatedUser!));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void changePage(){
    emit(ChangePage());
  }

  // Eye 1 new password
  void toggleNewPasswordVisibility1() {
    isObscure1 = !isObscure1;
    emit(ToggleNewPasswordVisibilityState(isObscure1));
  }

  // Eye 2 new password 2
  void toggleNewPasswordVisibility2() {
    isObscure2 = !isObscure2;
    emit(ToggleNewPasswordVisibilityState(isObscure2));
  }

  // Eye 2 new password 2
  void toggleNewPasswordVisibility3() {
    isObscure3 = !isObscure3;
    emit(ToggleNewPasswordVisibilityState(isObscure3));
  }

  // Change Password
  Future<void> changePasswordWithCurrent({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ProfileLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      emit(ProfilePasswordChangedSuccess());
    } catch (e) {
      emit(ProfilePasswordChangeError(e.toString()));
    }
  }

}
