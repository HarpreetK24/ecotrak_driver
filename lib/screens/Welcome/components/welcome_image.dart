import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              "WELCOME TO EcoTrak",
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              speed: const Duration(milliseconds: 100), // Adjust animation speed
            ),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                "assets/images/trash.png",
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
