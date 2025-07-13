import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCFB),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 229, 246, 245),
                    Color.fromARGB(255, 206, 238, 236),
                  ],
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
                    height: 425,
                    child: Center(
                      child: Image.asset(
                        'assets/images/man.png',
                        fit: BoxFit.contain,
                        height: 425,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Spend Smarter\nSave More',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4B807A),
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
                            context.go('/home');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF63B5AF), Color(0xFF438883)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: const Center(
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.white,
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
                        const Text(
                          'Already Have Account? ',
                          style: TextStyle(
                            color: Color(0xFF7A9B97),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF4B807A),
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
