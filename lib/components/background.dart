import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String topImage;
  final String bottomImage;

  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/main_top",  // Removed ".png"
    this.bottomImage = "assets/images/login_bottom",  // Removed ".png"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                '$topImage.png',  // Add ".png" extension here
                width: 120,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                '$bottomImage.png',  // Add ".png" extension here
                width: 120,
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
