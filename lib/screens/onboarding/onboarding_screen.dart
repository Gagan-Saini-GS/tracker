import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/utils/constants.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: onboardingGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Illustration placeholder
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 100),
                  child: SizedBox(
                    height: 350,
                    child: Center(
                      child: Image.asset(
                        'assets/images/man.png',
                        fit: BoxFit.contain,
                        height: 350,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Spend Smarter\nSave More',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 4,
                          ),
                          onPressed: () {
                            context.go('/signup');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: buttonGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already Have Account? ',
                          style: TextStyle(
                            color: greenColor.withGreen(160),
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
                              color: greenColor.withGreen(180),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
