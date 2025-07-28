import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/signup_provider.dart';

class SignupForm extends ConsumerWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signupFormProvider);
    final formNotifier = ref.read(signupFormProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: formNotifier.setName,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: form.nameError,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: formNotifier.setEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: form.emailError,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: formNotifier.setPassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: form.passwordError,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: form.isLoading
                ? null
                : () {
                    formNotifier.submit(context);
                  },
            child: form.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
