import 'package:flash_chat/screens/chat_screen.dart';

import '../widgets/mainButton.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  AnimationController controller;
  Animation animation;

  bool _isLoggedIn() {
    try {
      if (_auth.currentUser != null) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(curve: Curves.ease, parent: controller);

    // animation from one color to another. Also there several other Tween's
    // animation =
    //     ColorTween(begin: Colors.grey, end: Colors.black).animate(controller);
    controller.forward();

    // bouncing from small to big and reverse animation
    // controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed)
    //     controller.reverse(from: 1.0);
    //   else if (status == AnimationStatus.dismissed) controller.forward();
    // });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animation.value * 60.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 11,
                  child: TypewriterAnimatedTextKit(
                    text: ['Flash Chat'],
                    speed: Duration(milliseconds: 250),
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48.0),
            Hero(
              tag: 'loginButton',
              child: MainButton(
                title: 'Log In',
                color: Colors.amberAccent,
                onPressed: () {
                  if (_isLoggedIn())
                    Navigator.pushNamed(context, ChatScreen.id);
                  else
                    Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            Hero(
              tag: 'registerButton',
              child: MainButton(
                title: 'Register',
                color: Colors.amber,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
