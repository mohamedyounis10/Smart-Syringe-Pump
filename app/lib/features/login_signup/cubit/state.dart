abstract class AuthState {}

class InitState extends AuthState {}

/// 🔹 Auth Status States
class AuthStatusState extends AuthState {
  final bool isAuthenticated;
  final String? userId;
  AuthStatusState({required this.isAuthenticated, this.userId});
}

/// 🔹 Shared
class EmailState extends AuthState {
  final String email;
  EmailState(this.email);
}

class PasswordState extends AuthState {
  final String pass;
  PasswordState(this.pass);
}

class NameState extends AuthState {
  final String name;
  NameState(this.name);
}

class PhoneState extends AuthState {
  final String phone;
  PhoneState(this.phone);
}

class ToggleState extends AuthState {
  final bool show;
  ToggleState(this.show);
}

class LoadingState extends AuthState {}
class SuccessState extends AuthState {
}
class FailureState extends AuthState {
  final String error;
  FailureState(this.error);
}
class ErrorState extends AuthState {}
class CheckboxState extends AuthState {
  final bool isCheck;
  CheckboxState(this.isCheck);
}

/// 🔹 Navigation
class NextPageState extends AuthState {}
class ReturnPageState extends AuthState {}
class PasswordPageState extends AuthState {}

/// 🔹 Forget Password – Step 1: Select Method
class SelectionUpdatedState extends AuthState {
  final String selectedMethod; // email or phone
  SelectionUpdatedState(this.selectedMethod);
}

class SelectionErrorState extends AuthState {
  final String message;
  SelectionErrorState(this.message);
}

class ProceedToConfirmationState extends AuthState {}

// Forget Password – Step 2: Confirm Code
class ConfirmLoadingState extends AuthState {}
class ConfirmSuccessState extends AuthState {}
class ConfirmFailureState extends AuthState {
  final String message;
  ConfirmFailureState(this.message);
}

// Forget Password – Step 3: Reset Password
class ToggleNewPasswordVisibilityState extends AuthState {
  final bool isObscure;
  ToggleNewPasswordVisibilityState(this.isObscure);
}

class NewPasswordUpdatedState extends AuthState {
  final String password;
  NewPasswordUpdatedState(this.password);
}

class ConfirmNewPasswordUpdatedState extends AuthState {
  final String password;
  ConfirmNewPasswordUpdatedState(this.password);
}

class ResetPasswordLoadingState extends AuthState {}
class ResetPasswordSuccessState extends AuthState {}
class ResetPasswordFailureState extends AuthState {
  final String message;
  ResetPasswordFailureState(this.message);
}
class RedirectToSignupState extends AuthState {}
