import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:one_food/ui/select_location.dart';
import 'dart:async';

//void main() {
//  runApp(MaterialApp(
//    debugShowCheckedModeBanner: false,
//    home: FirebasePhoneAuth(),
//  ));
//}

String verificationCode = "";

enum TimerState { Show, Hide }

enum ResendButtonState { Show, Hide }

enum VerificationType { Normal, Resend }

ResendButtonState _resendButtonState = ResendButtonState.Hide;
VerificationType _verificationType = VerificationType.Normal;
TimerState _timerState = TimerState.Hide;

class FirebasePhoneAuth extends StatefulWidget {
  String phoneNumber;

  FirebasePhoneAuth(this.phoneNumber);

  @override
  _FirebasePhoneAuthState createState() => _FirebasePhoneAuthState();
}

class _FirebasePhoneAuthState extends State<FirebasePhoneAuth> {
  String phone, actualCode;

  PinField pf = new PinField();

  AuthCredential _authCredential;

  FirebaseAuth firebaseAuth;

  int time = 60;
  String status = 'Sending the verification code...';
  int resendToken;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    phone = widget.phoneNumber;
    startVerification();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 1.25 / 10),
              Text('Verify your identity',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700)),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(status,
                      style: TextStyle(color: Colors.black, fontSize: 16.0))),
              Form(child: pf),
              SizedBox(height: 20.0),
              _timerState == TimerState.Show
                  ? Text(
                      'Wait for $time seconds to resend the code',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    )
                  : Container(),
              _resendButtonState == ResendButtonState.Show
                  ? InkWell(
                      onTap: () {
                        _verificationType = VerificationType.Resend;
                        setState(() {
                          _resendButtonState = ResendButtonState.Hide;
                        });
                        startVerification();
                      },
                      child: Text('Resend verification code',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue, fontSize: 16.0)))
                  : Container(),
              SizedBox(height: 20.0),
              RaisedButton(
                elevation: 15.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                onPressed: () {
                  _signInWithPhoneNumber(verificationCode);
                },
                child: SizedBox(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 7 / 10,
                ),
                color: Colors.blue,
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithPhoneNumber(String smsCode) async {
    _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        status = 'Something has gone wrong, please try later';
      });
    }).then((FirebaseUser user) async {
      setState(() {
        status = 'Authentication successful';
      });
      onAuthenticationSuccessful();
    });
  }

  startVerification() async {
    print('Starting verification');
    firebaseAuth = await FirebaseAuth.instance;
    if (firebaseAuth.currentUser() != null) firebaseAuth.signOut();

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      setState(() {
        status = 'Auto retrieving verification code';
      });
      //_authCredential = auth;

      firebaseAuth.signInWithCredential(auth).catchError((error) {
        setState(() {
          status = 'Something has gone wrong, please try later';
        });
        print("Signin with credential : " + error.toString());
      }).then((FirebaseUser user) async {
        setState(() {
          status = 'Authentication successful';
        });
        print("Success " + user.uid.toString());
        onAuthenticationSuccessful();
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        status = '${authException.message}';

        print("Error message: " + status);
        if (authException.message.contains('not authorized'))
          status = 'Something has gone wrong, please try later';
        else if (authException.message.contains('Network'))
          status = 'Please check your internet connection and try again';
        else
          status = 'Something has gone wrong, please try later';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.actualCode = verificationId;
      setState(() {
        print('Code sent to $phone');
        status = "\nEnter the code sent to " + phone;
        _timerState = TimerState.Show;
        //"\nwith verification code $verificationId";
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.actualCode = verificationId;
      setState(() {
        status = "\nAuto retrieval time out";
      });
    };

    if (_verificationType == VerificationType.Normal) {
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } else {
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          forceResendingToken: resendToken,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        time--;
        if (time == 0) {
          _timerState = TimerState.Hide;
          _resendButtonState = ResendButtonState.Show;
          time = 60;
        }
      });
    });
  }

  onAuthenticationSuccessful() {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => SelectLocation()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }
}

int fields = 6;

class PinField extends StatefulWidget {
  @override
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  List<FocusNode> _focusNodes = List(fields);
  List<TextEditingController> _controllers = List(fields);

  buildTextFields() {
    List<Widget> list = [];

    for (int i = 0; i < fields; i++) {
      _controllers[i] = TextEditingController();
      _focusNodes[i] = FocusNode();

      list.add(Container(
        height: 50.0,
        width: 50.0,
        padding: const EdgeInsets.all(3.0),
        child: TextField(
          controller: _controllers[i],
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          style: TextStyle(
              color: Colors.blue, fontSize: 20.0, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          onChanged: (val) {
            if (val.length == 1) {
              if (i == fields - 1) {
                FocusScope.of(context).requestFocus(_focusNodes[i]);
                print('done');
                done();
              } else {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              }
            }
          },
          onSubmitted: (value) {
            if (i == fields - 1) {
              done();
            }
          },
          maxLines: 1,
          focusNode: _focusNodes[i],
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(border: OutlineInputBorder()),
          keyboardType: TextInputType.numberWithOptions(),
        ),
      ));
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
    return list;
  }

  displayErrorDialog() {}

  done() {
    String data = '';
    _controllers.forEach((TextEditingController c) {
      if (c.text == null) {
        displayErrorDialog();
      } else {
        data += c.text;
      }
    });
    print(data);
    verificationCode = data;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: buildTextFields(),
      ),
    );
  }
}
