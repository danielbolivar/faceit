import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        _buildPage(
          title: 'Welcome to FaceIt',
          description: 'Your personal finance companion.',
          image: 'assets/images/onboarding1.png',
        ),
        _buildPage(
          title: 'Track Expenses',
          description: 'Easily track your daily expenses.',
          image: 'assets/images/onboarding1.png',
        ),
        _buildPage(
          title: 'Set Budgets',
          description: 'Manage your budgets effectively.',
          image: 'assets/images/onboarding1.png',
        ),
      ],
    );
  }
}

Widget _buildPage({
  required String title,
  required String description,
  required String image,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(image, height: 200),
      const SizedBox(height: 20),
      Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
