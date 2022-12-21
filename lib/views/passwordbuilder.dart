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

class PassWordMaker extends StatefulWidget {
  const PassWordMaker({Key? key}) : super(key: key);

  @override
  State<PassWordMaker> createState() => _PassWordMakerState();
}

class _PassWordMakerState extends State<PassWordMaker> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteNameController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  dynamic _webImage;

  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  final DataService _dataService=DataService();


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }








  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        title: const Text("PASS-BOX"),
        actions: <Widget>[
          appBarButton(platform, context),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataService.getData(),
        builder: (context, snaphot) {
          return !snaphot.hasData
              ? const CustomLoading()
              : snaphot.data != null
              ? _mainBody(snaphot)
              : const CustomLoading();
        },
      ),
      floatingActionButton: floatingActionButton(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: containerDecoration(),
              height: 200,

              child: Center(
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: <Widget>[
                  Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: Text("ADD ACCOUNT INFO",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
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
                                Navigator.pop(context);
                              }).catchError((error) {
                                _warningToast(BoxText.errorText);
                              }).whenComplete(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added successfuly')),
                                );
                              });

                              Navigator.pop(context);
                            }

                          },
                        ),
                      ),
                    ],
                  ),
                ),

                  ],
                ),
              ),
            );
          },
        );
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
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
                  return _alertDialog(mypost);
                });
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                _showChoiseDialog(context);
              },
              child: _dietListContainer(mypost),
            ),
          );
        });
  }


  InkWell _removeButton(DocumentSnapshot mypost) {
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

  InkWell _giveUpButton() {
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${mypost['siteName']}",
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${mypost['emailAddress']}",
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${mypost['passWord']}",
          ),

        ],
      ),
    );
  }

  AlertDialog _alertDialog(DocumentSnapshot mypost) {
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
      content: _alertDialogContent(mypost),
    );
  }

  Row _alertDialogContent(DocumentSnapshot mypost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _removeButton(mypost),
        _giveUpButton(),
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
  BoxDecoration containerDecoration() {
    return const BoxDecoration(
      color: Colors.amber,
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
  IconButton appBarButton(TargetPlatform platform, BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app_sharp),
      tooltip: 'Press to exit',
      onPressed: () {
        if (platform == TargetPlatform.iOS) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Exit ?'),
              content: const Text('Are you sure ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //if (_authService.signOut()) {
                      _authService.signOut();
                      Navigator.of(context).pushReplacementNamed('/');
                    //}
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Exit ?'),
              content: const Text('Are you sure ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //if (_authService.signOut()) {
                      _authService.signOut();
                    //}
                      Navigator.of(context).pushReplacementNamed('/');

                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        }
        //Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }
}
