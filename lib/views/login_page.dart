import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passbox/constants/app_constant.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  final now = DateTime.now();
  final String evening = "Good Evening";
  final String night = "Good Night";
  final String morning = "Good Morning";
  final String afternoon = "Good Afternoon";

  String msgToshow() {
    String correctMessage = "Loading ...";
    if (now.hour >= 6 && now.hour <= 12) {
      correctMessage = morning;
    } else if (now.hour > 12 && now.hour <= 18) {
      correctMessage = afternoon;
    } else if (now.hour >= 19 && now.hour <= 21) {
      correctMessage = evening;
    } else {
      correctMessage = night;
    }
    return correctMessage;
  }



  final _formKey = GlobalKey<FormState>();

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
                iconKey(),
                bigSizedBoxSeparator(),
                greatingMessage(),
                hourMessage(),
                bigSizedBoxSeparator(),
                loginForm(context),
                createAccountMessage(),
                registerPageLink(context),
              ],
            );
          } else {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                iconKey(),
                bigSizedBoxSeparator(),
                greatingForLandscape(),
                hourMessageForLanscape(),
                bigSizedBoxSeparator(),
                loginForm(context),
                createAccountMessage(),
                registerPageLink(context),
              ],
            );
          }
        }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Center greatingForLandscape() {
    return const Center(
      child: Text(
        'Hello',
        style: TextStyle(
            fontSize: 90, color: Colors.white, fontWeight: FontWeight.w800),
      ),
    );
  }

  Center hourMessageForLanscape() {
    return Center(
      child: hourMessage(),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          emailInput(),
          passWordInput(),
          resetPassword(),
          const SizedBox(
            height: 20,
          ),
          signinButton(context),
        ],
      ),
    );
  }

  TextButton registerPageLink(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/register');
      },
      child: const Text('REGISTER'),
    );
  }

  Center createAccountMessage() {
    return const Center(
      child: Text(
        "Don't have an account?",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Center signinButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              _authService
                  .signInWithEmail(
                _emailController.text,
                _passwordController.text,
              )
                  .then((value) {
                Navigator.of(context).pushReplacementNamed('/passwordbuilder');
              }).catchError((error) {
                if (error.toString().contains('invalid-email')) {
                  _warningToast(BoxText.loginWrongEmailText);
                } else if (error.toString().contains('user-not-found')) {
                  _warningToast(BoxText.loginNoAccountText);
                } else if (error.toString().contains('wrong-password')) {
                  _warningToast(BoxText.loginWrongPasswordText);
                } else {
                  _warningToast(BoxText.errorText);
                }
              }).whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Welcome Back')),
                );
              });
            }
          },
          child: const Text('SIGN IN'),
        ),
      ),
    );
  }

  Align resetPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
        child: const Text("Forgot your password?"),
      ),
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

  TextFormField passWordInput() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(color: Colors.white),
      obscureText: true,
      decoration: const InputDecoration(
        icon: FaIcon(
          FontAwesomeIcons.lock,
          color: Colors.white,
        ),
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: Colors.white),
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

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        icon: FaIcon(
          FontAwesomeIcons.envelope,
          color: Colors.white,
        ),
        hintText: 'Enter your email',
        hintStyle: TextStyle(color: Colors.white),
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

  SizedBox bigSizedBoxSeparator() {
    return const SizedBox(
      height: 50,
    );
  }

  Text hourMessage() {
    return Text(
      msgToshow(),
      style: const TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
    );
  }

  Text greatingMessage() {
    return const Text(
      'Hello',
      style: TextStyle(
          fontSize: 90, color: Colors.white, fontWeight: FontWeight.w800),
    );
  }

  Center iconKey() {
    return const Center(
      child: FaIcon(
        FontAwesomeIcons.key,
        size: 100,
        color: Colors.white,
      ),
    );
  }
}
