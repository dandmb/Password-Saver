import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:passbox/data_service.dart';

import '../constants/app_constant.dart';
import '../constants/custom_loading.dart';
import '../services/auth_service.dart';

class AddDataForm extends StatelessWidget {

  Future<bool> _onWillPop(BuildContext context) async {

    bool? exitResult = await showDialog(

      context: context,

      builder: (context) => _buildExitDialog(context),

    );

    return exitResult ?? false;

  }
  Future<bool?> _showExitDialog(BuildContext context) async {

    return await showDialog(

      context: context,

      builder: (context) => _buildExitDialog(context),

    );

  }
  AlertDialog _buildExitDialog(BuildContext context) {

    return AlertDialog(

      title: const Text('Please confirm'),

      content: const Text('Do you want to exit the app?'),

      actions: <Widget>[

        TextButton(

          onPressed: () => Navigator.of(context).pop(false),

          child: Text('No'),

        ),

        TextButton(

          onPressed: () {
            _authService.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          },

          child: Text('Yes'),

        ),

      ],

    );

  }
  
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteNameController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  dynamic _webImage;

  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  final DataService _dataService=DataService();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            websiteNameInput(),
                            emailInput(),
                            passwordInput(),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                child: const Text('Save'),
                                onPressed: (){
                                  if (_formKey.currentState!.validate()) {

                                    _dataService
                                        .addData(_websiteNameController.text,_emailController.text,_passwordController.text)
                                        .then((value) {
                                      //Navigator.pop(context);
                                    }).catchError((error) {
                                      _warningToast(BoxText.errorText);
                                    }).whenComplete(() {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added successfuly')),
                                      );
                                    });

                                    _passwordController.clear();
                                    _emailController.clear();
                                    _websiteNameController.clear();
                                  }

                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            websiteNameInput(),
                            emailInput(),
                            passwordInput(),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                child: const Text('Save'),
                                onPressed: (){
                                  if (_formKey.currentState!.validate()) {

                                    _dataService
                                        .addData(_websiteNameController.text,_emailController.text,_passwordController.text)
                                        .then((value) {
                                      //Navigator.pop(context);
                                    }).catchError((error) {
                                      _warningToast(BoxText.errorText);
                                    }).whenComplete(() {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added successfuly')),
                                      );
                                      _passwordController.clear();
                                      _emailController.clear();
                                      _websiteNameController.clear();
                                    });

                                    //Navigator.pop(context);
                                  }

                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
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
  BoxDecoration containerDecoration() {
    return const BoxDecoration(
      //color: Colors.amber,
      /*
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0),
      ),*/
    );
  }
  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        icon: FaIcon(
          FontAwesomeIcons.envelope,
          color: Colors.black,
        ),
        hintText: 'Enter the email',
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
  TextFormField websiteNameInput() {
    return TextFormField(
      controller: _websiteNameController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        icon: Icon(
          Icons.web,
          color: Colors.black,
        ),
        hintText: 'Enter the website name',
        hintStyle: TextStyle(color: Colors.black),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 3) {
          return 'The field can not be empty or length less than 3';
        }
        return null;
      },
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        icon: Icon(
          Icons.key_sharp,
          color: Colors.black,
        ),
        hintText: 'Enter the website password',
        hintStyle: TextStyle(color: Colors.black),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 2) {
          return 'The field can not be empty or length less than 2';
        }
        return null;
      },
    );
  }
}