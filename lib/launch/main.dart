

import 'package:flutter/material.dart';
import 'package:passbox/views/pass_management.dart';
import 'package:passbox/views/passwordbuilder.dart';
import 'package:passbox/views/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import '../views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PSaver',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      //home: const LoginPage(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const LoginPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/register': (context) => const RegisterPage(),
        '/passwordbuilder': (context) => const AllAccounts(),
      },
    );
  }
}
