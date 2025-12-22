import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dose/features/login_signup/cubit/state.dart';
import '../../../core/db/firebase.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(InitState()) {
    _initializeAuthListener();
  }

  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription;

  // Initialize auth state listener
  void _initializeAuthListener() {
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in
        emit(AuthStatusState(isAuthenticated: true, userId: user.uid));
      } else {
        // User is logged out
        emit(AuthStatusState(isAuthenticated: false, userId: null));
      }
    });
  }

  // Check current auth status
  void checkAuthStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthStatusState(isAuthenticated: true, userId: user.uid));
    } else {
      emit(AuthStatusState(isAuthenticated: false, userId: null));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  // Shared
  bool isObscure = true;
  bool isChecked = false;
  String _email = '';
  String _password = '';
  String _name = '';
  String selectedMethod = "phone";


  // Email
  void updateEmail(String email) {
    _email = email;
    emit(EmailState(email));
  }

  // Name
  void updateName(String name) {
    _name = name;
    emit(NameState(name));
  }

  // Password
  void updatePassword(String password) {
    _password = password;
    emit(PasswordState(password));
  }

  String _phone = '';

  void updatePhone(String phone) {
    _phone = phone;
    emit(PhoneState(phone));
  }

  // Eye in login screen
  void togglePasswordVisibility() {
    isObscure = !isObscure;
    emit(ToggleState(isObscure));
  }

  // Login
  Future<void> login() async {
    emit(LoadingState());
    try {
      final user = await _firebaseService.login(
        email: _email,
        password: _password,
      );
      emit(SuccessState());
      // Auth state will be updated automatically by the listener
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  // Signup
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(LoadingState());
    try {
      await _firebaseService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      emit(SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }


  // Terms check box
  void checkBox() {
    isChecked = !isChecked;
    emit(CheckboxState(isChecked));
  }

  // Reset password by email
  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoadingState());

    try {
      await _firebaseService.sendPasswordResetEmail(email);
      emit(ResetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(RedirectToSignupState());
      } else if (e.code == 'invalid-email') {
        emit(ResetPasswordFailureState("Invalid email address"));
      } else if (e.code == 'empty-email') {
        emit(ResetPasswordFailureState("Please enter your email"));
      } else {
        emit(ResetPasswordFailureState("Error: ${e.message}"));
      }
    } catch (e) {
      emit(ResetPasswordFailureState("Unexpected error: $e"));
    }
  }

  // Error
  void errorMessage() {
    emit(ErrorState());
  }

  // Navigation
  void nextPage() {
    emit(NextPageState());
  }

  void returnPage() {
    emit(ReturnPageState());
  }

  void PasswordPage() {
    emit(PasswordPageState());
  }

  // Logout
  Future<void> logout() async {
    try {
      await _firebaseService.logout();
      // Auth state will be updated automatically by the listener
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}