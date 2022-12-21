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

class AllData extends StatelessWidget {
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();

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
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: StreamBuilder<QuerySnapshot>(
        stream: _dataService.getData(),
        builder: (context, snaphot) {
          return !snaphot.hasData
              ? const CustomLoading()
              : snaphot.data != null
                  ? _mainBody(snaphot)
                  : const CustomLoading();
        },
      ),
    );
  }

  ListView _mainBody(AsyncSnapshot<QuerySnapshot<Object?>> snaphot) {
    return ListView.builder(
        itemCount: snaphot.data?.docs.length ?? 0,
        itemBuilder: (context, index) {
          DocumentSnapshot mypost = snaphot.data!.docs[index];

          Future<void> _showChoiseDialog(BuildContext context) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _alertDialog(mypost, context);
                });
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                _showChoiseDialog(context);
              },
              child: _dietListContainer(mypost),
            ),
          );
        });
  }

  InkWell _removeButton(DocumentSnapshot mypost, BuildContext context) {
    return InkWell(
      onTap: () {
        _dataService.removeData(mypost.id);
        Navigator.pop(context);
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  InkWell _giveUpButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Container _dietListContainer(DocumentSnapshot mypost) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: _dietListColumn(mypost),
    );
  }

  Padding _dietListColumn(DocumentSnapshot mypost) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "${mypost['siteName'].toUpperCase()}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "${mypost['emailAddress']}",
              style: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "${mypost['passWord']}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog _alertDialog(DocumentSnapshot mypost, BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Account',
        textAlign: TextAlign.center,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      content: _alertDialogContent(mypost, context),
    );
  }

  Row _alertDialogContent(DocumentSnapshot mypost, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _removeButton(mypost, context),
        _giveUpButton(context),
      ],
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
}
