import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupFormState {
  final String name;
  final String email;
  final String password;
  final bool isLoading;

  final String? nameError;
  final String? emailError;
  final String? passwordError;

  SignupFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.nameError,
    this.emailError,
    this.passwordError,
  });

  SignupFormState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLoading,
    String? nameError,
    String? emailError,
    String? passwordError,
  }) {
    return SignupFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
    );
  }
}

class SignupFormNotifier extends StateNotifier<SignupFormState> {
  SignupFormNotifier() : super(SignupFormState());

  void setName(String name) {
    state = state.copyWith(name: name, nameError: null);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, passwordError: null);
  }

  bool _validate() {
    bool isValid = true;

    if (state.name.trim().isEmpty) {
      state = state.copyWith(nameError: 'Name is required');
      isValid = false;
    }

    if (!_isValidEmail(state.email)) {
      state = state.copyWith(emailError: 'Enter a valid email');
      isValid = false;
    }

    if (state.password.length < 6) {
      state = state.copyWith(
        passwordError: 'Password must be at least 6 characters',
      );
      isValid = false;
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> submit(BuildContext context) async {
    if (!_validate() && !mounted) return;

    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2)); // Fake API

    state = state.copyWith(isLoading: false);

    context.go("/home");
    // TODO: Handle real signup logic
  }
}

final signupFormProvider =
    StateNotifierProvider<SignupFormNotifier, SignupFormState>((ref) {
      return SignupFormNotifier();
    });
