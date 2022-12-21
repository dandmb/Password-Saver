
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import '../services/auth_service.dart';
import 'add_data_form.dart';
import 'list_of_account.dart';


class AllAccounts extends StatefulWidget {
  const AllAccounts({Key? key}) : super(key: key);

  @override
  State<AllAccounts> createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {


  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

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
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple[900],
        onTap: _onItemTapped,
      ),
    );
  }
  Widget getBody( )  {
    if(_selectedIndex == 0) {
      return AllData();
    }else {
      return AddDataForm();
    }
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
              title: const Text('Please confirm'),
              content: const Text('Do you want to exit the app ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //if (_authService.signOut()) {
                      _authService.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      //Navigator.of(context).pushReplacementNamed('/');
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
              title: const Text('Please confirm'),
              content: const Text('Do you want to exit the app ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //if (_authService.signOut()) {
                      _authService.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

                      //Navigator.of(context).pushReplacementNamed('/');
                    //}
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


/*
*/