import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  Widget _getBodyMyAccount() {
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.all(25.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      color: Colors.white,
      child: SizedBox(
        height: 150.0,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/a/hotel.png'),
                radius: 50.0,
              ),
              SizedBox(width: 20.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Hello ',
                          style: TextStyle(color: Colors.blue, fontSize: 20.0,fontWeight: FontWeight.w400)),
                      Text('Guest',
                          style: TextStyle(color: Colors.blue, fontSize: 24.0,fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_getBodyMyAccount()],
        ),
      ),
    );
  }
}
