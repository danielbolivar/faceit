import 'package:flutter/material.dart';
import 'package:forui/widgets/button.dart';

class ContinueButton extends StatefulWidget {
  const ContinueButton({
    super.key,
    required this.context,
    required PageController pageController,
  }) : _pageController = pageController;

  final BuildContext context;
  final PageController _pageController;

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  bool get _isLastPage {
    return widget._pageController.page?.round() ==
        widget._pageController.positions.first.maxScrollExtent.round();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: 10,
      ),
      child: FButton(
        style: FButtonStyle.secondary,
        onPress: () {
          widget._pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: const Text('Continue'),
      ),
    );
  }
}
