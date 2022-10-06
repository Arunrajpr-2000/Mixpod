import 'package:flutter/material.dart';
import 'package:mixpod/screens/home.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../functions/functions.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    fetchingsongs();
    gotohome();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/172876e3ef491d0bd9e9de1b0ded5233-removebg-preview.png"),
                    fit: BoxFit.cover),
              ),
            ),
            GradientText("M I X P O D",
                style: const TextStyle(
                    fontFamily: "poppinz",
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
                colors: const [
                  Color(0xffdd0021),
                  Color(0xff2b2b29),
                ])
          ],
        ),
      ),
    );
  }

  Future<void> gotohome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ScreenHome(audiosongs: audiosongs),
      ),
    );
  }
}
