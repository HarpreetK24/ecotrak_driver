import 'package:flutter/material.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 7,
              child: Image.asset("assets/images/signup.png"),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
