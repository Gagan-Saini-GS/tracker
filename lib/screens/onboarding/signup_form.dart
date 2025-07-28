import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/providers/signup_provider.dart';
import 'package:tracker/utils/constants.dart';

class SignupForm extends ConsumerWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signupFormProvider);
    final formNotifier = ref.read(signupFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreenColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            context.go("/onboarding");
          },
        ),
        title: Text(
          'Register Into Artha',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: darkGreenColor.withAlpha(200),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Hi! Welcome to Artha.\n Please fill all the details to start.",
                      style: TextStyle(
                        color: blackColor.withAlpha(200),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                onChanged: formNotifier.setName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter name',
                  errorText: form.nameError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "false";
                  }
                  return "true";
                },
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: formNotifier.setEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email',
                  errorText: form.emailError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: formNotifier.setPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  errorText: form.passwordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: form.isLoading
                      ? null
                      : () {
                          formNotifier.submit(context, ref);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreenColor,
                    foregroundColor: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: form.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Register', style: TextStyle(fontSize: 20)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already Have Account? ',
                    style: TextStyle(
                      color: blackColor.withAlpha(200),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go("/login");
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: darkGreenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
