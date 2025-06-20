import 'dart:developer';

import 'package:faceit/features/onboarding/views/continue_button.dart';
import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController = PageController();

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
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
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
              padding: const EdgeInsets.all(16),
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
            ContinueButton(context: context, pageController: _pageController),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
  return LayoutBuilder(
    builder: (context, constraints) {
      // Responsive padding based on screen width
      final screenWidth = constraints.maxWidth;
      final horizontalPadding = screenWidth < 400
          ? 24.0
          : screenWidth < 600
          ? 35.0
          : 50.0;

      final titleTopIndent =
          constraints.maxHeight * 0.12; // 12% of screen height
      final titleToBodySpacing = 40.0;
      final bodyToImageSpacing = 30.0;

      return Column(
        children: [
          // Title section with top spacing
          Padding(
            padding: EdgeInsets.only(
              top: titleTopIndent,
              bottom: titleToBodySpacing,
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FThemes.zinc.dark.colors.foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                fontSize: screenWidth < 400 ? 28 : 32,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Expanded(flex: 3, child: Text(title)),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // Body section (description + image)
          Expanded(
            flex: 10,
            child: DefaultTextStyle(
              style: TextStyle(
                color: FThemes.zinc.dark.colors.mutedForeground,
                fontSize: 16,
                height: 1.5,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    // Description
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth < 400 ? 14 : 16),
                    ),

                    SizedBox(height: bodyToImageSpacing),

                    // Image with responsive sizing
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight:
                              constraints.maxHeight *
                              0.4, // Max 40% of screen height
                          maxWidth:
                              screenWidth * 0.8, // Max 80% of screen width
                        ),
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: FThemes.zinc.dark.colors.muted,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: FThemes.zinc.dark.colors.mutedForeground,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom spacing
          const SizedBox(height: 20),
        ],
      );
    },
  );
}
