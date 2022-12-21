import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import '../services/auth_service.dart';
import '../constants/app_constant.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  dynamic _profileImage = '';
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
        child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                keyIcon(),
                bigSeparateur(),
                Container(
                  decoration: containerDecoration(),
                  child: Column(
                    children: [
                      separaTeur(),
                      createAccountMsg(),
                      bigSeparateur(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              inputName(),
                              inputMail(),
                              inputPassword(),
                              separaTeur(),
                              submitButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                separaTeur(),
                alreadyhaveAccount(),
                loginRedirect(context),
              ],
            );
          } else {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Center(
                  child: keyIcon(),
                ),
                bigSeparateur(),
                Container(
                  decoration: containerDecoration(),
                  child: Column(
                    children: [
                      createAccountMsg(),
                      bigSeparateur(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              inputName(),
                              inputMail(),
                              inputPassword(),
                              separaTeur(),
                              submitButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                separaTeur(),
                alreadyhaveAccount(),
                loginRedirect(context),
              ],
            );
          }
        }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  FaIcon keyIcon() {
    return const FaIcon(
      FontAwesomeIcons.key,
      size: 100,
      color: Colors.white,
    );
  }

  BoxDecoration containerDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        bottomLeft: Radius.circular(30.0),
      ),
    );
  }

  SizedBox bigSeparateur() {
    return const SizedBox(
      height: 50,
    );
  }

  SizedBox separaTeur() {
    return const SizedBox(
      height: 20,
    );
  }

  TextButton loginRedirect(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
      child: const Text('LOGIN HERE'),
    );
  }

  Center alreadyhaveAccount() {
    return const Center(
      child: Text(
        "Already have an account?",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Center submitButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {

              _authService
                  .createPerson(
                _usernameController.text,
                _emailController.text,
                _passwordController.text,
                _profileImage ?? '',

              )
                  .then((value) {
                Navigator.of(context).pushReplacementNamed('/');
              }).catchError((error) {
                _warningToast(BoxText.errorText);
              }).whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration Done')),
                );
              });
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.

            }
          },
          child: const Text('SIGN UP'),
        ),
      ),
    );
  }

  TextFormField inputPassword() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(color: Colors.black),
      obscureText: true,
      decoration: const InputDecoration(
        icon: FaIcon(
          FontAwesomeIcons.lock,
          color: Colors.black,
        ),
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: Colors.black),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );
  }
  Future<bool?> _warningToast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14);
  }
  TextFormField inputMail() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        icon: FaIcon(
          FontAwesomeIcons.envelope,
          color: Colors.black,
        ),
        hintText: 'Enter your email',
        hintStyle: TextStyle(color: Colors.black),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 8) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  TextFormField inputName() {
    return TextFormField(
      controller: _usernameController,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        icon: Icon(
          Icons.person,
          color: Colors.black,
        ),
        hintText: 'Enter your name',
        hintStyle: TextStyle(color: Colors.black),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty || value.length <= 2) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Text createAccountMsg() {
    return const Text(
      "Create new Account",
      style: TextStyle(
          fontSize: 30, color: Colors.black, fontWeight: FontWeight.w800),
    );
  }
}
