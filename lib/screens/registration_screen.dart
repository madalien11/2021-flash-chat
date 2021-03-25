import 'chat_screen.dart';
import '../widgets/mainButton.dart';
import '../constants.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String username = '';
  String password = '';
  bool _passVisible = false;
  bool _showSpinner = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  controller: _usernameController,
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your username'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: !_passVisible,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                          icon: Icon(
                              _passVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.amber),
                          onPressed: () => setState(() {
                                _passVisible = !_passVisible;
                              }))),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Hero(
                  tag: 'registerButton',
                  child: MainButton(
                    title: 'Register',
                    color: Colors.amber,
                    onPressed: () async {
                      setState(() {
                        _showSpinner = true;
                      });
                      FocusScope.of(context).unfocus();
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: username + '@random.com',
                                password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          _usernameController.clear();
                          _passwordController.clear();
                        }
                      } catch (e) {
                        showMyDialog(context, e.toString());
                      } finally {
                        setState(() {
                          _showSpinner = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
