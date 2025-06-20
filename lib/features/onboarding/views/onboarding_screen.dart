import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController = PageController();

  int _currentPage = 0;
  int get _pageCount => 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FThemes.zinc.dark.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pageCount,
                effect: ColorTransitionEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: FThemes.zinc.dark.colors.primary,
                  dotColor: FThemes.zinc.dark.colors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
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
