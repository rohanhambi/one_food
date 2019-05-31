import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:one_food/login/firebase_login.dart';
import 'package:one_food/widgets/progress_button.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}

double fontSize;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController slideUpController, slideUpController2;
  Animation slideUp, slideUp2;

  double op = 1.0;

  @override
  void initState() {
    super.initState();
    slideUpController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    slideUp = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: slideUpController, curve: Curves.fastOutSlowIn));

    slideUpController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    slideUp2 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: slideUpController2, curve: Curves.fastOutSlowIn));
  }

  @override
  Widget build(BuildContext context) {

    //fontSize = MediaQuery.of(context).size.height * 0.28 / 10;

    fontSize = 19.0;

    Future.delayed(Duration(seconds: 5)).then((value) {
      slideUpController.forward();
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(flex: 6, child: SizedBox()),
              AnimatedBuilder(
                  animation: slideUp,
                  builder: (context, child) {
                    return Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            -MediaQuery.of(context).size.width /
                                5 *
                                slideUpController.value,
                            0.0),
                        child: Center(
                          child: SizedBox(
                              child: Image.asset('assets/logo.png'),
                              height:
                                  MediaQuery.of(context).size.height * 4 / 10),
                        ));
                  }),
              AnimatedBuilder(
                  animation: slideUp,
                  builder: (context, child) {
                    return Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            -MediaQuery.of(context).size.width /
                                4.5 *
                                slideUpController.value,
                            0.0),
                        child: Opacity(
                          opacity: slideUpController.value,
                          child: Container(
                            margin: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              'OneFood - your hunger our service\nWe deliver all kinds of foods in Armoor area, Nizamabad',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: MediaQuery.of(context).size.height * 0.28 / 10,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ));
                  }),
              AnimatedBuilder(
                  animation: slideUp,
                  builder: (context, child) {
                    return Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            -MediaQuery.of(context).size.width /
                                5.5 *
                                slideUpController.value,
                            0.0),
                        child: Opacity(
                          opacity: op,
                          child: Opacity(
                            opacity: slideUpController.value,
                            child: RaisedButton(
                              elevation: 15.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                              onPressed: () {
                                slideUpController2.forward();
                                setState(() {
                                  op = 0.0;
                                });
                              },
                              color: Colors.green.withOpacity(0.9),
                              child: Text(
                                ' Login ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.height * 0.28 / 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ));
                  }),
              Expanded(flex: 3, child: SizedBox()),
            ],
          ),
        ],
      ),
      bottomSheet: AnimatedBuilder(
          animation: slideUp2,
          builder: (context, child) {
            return Opacity(
              opacity: slideUpController2.value,
              child: _Bottom(),
            );
          }),
    );
  }
}

class _Bottom extends StatefulWidget {
  @override
  __BottomState createState() => __BottomState();
}

class __BottomState extends State<_Bottom> {
  Color textColor = Colors.redAccent;
  var key = GlobalKey<FormState>();


  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _textEditingController.addListener(() {
      if (_textEditingController.text.length == 10)
        setState(() {
          textColor = Colors.white;
        });
      else
        setState(() {
          textColor = Colors.red;
        });
    });

    double fontS = MediaQuery.of(context).size.height*0.28/10;

    return Container(
        decoration: ShapeDecoration(
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)))),
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            SizedBox(width: 15.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 7 / 10,
              child: Form(
                key: key,
                child: TextFormField(
                    //onChanged: (String phone) {},
                    controller: _textEditingController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: ' Enter your phone    ',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: fontS,
                          fontWeight: FontWeight.w700),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      prefix: Text(
                        ' +91 ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: fontS,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    style: TextStyle(
                        color: textColor,
                        fontSize: fontS,
                        fontWeight: FontWeight.w700)
//                    style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w700),
                    ),
              ),
            ),
            SizedBox(width: 15.0),
            Material(
              type: MaterialType.circle,
              elevation: 10.0,
              color: Colors.green,
              child: InkWell(
                onTap: () {
                  print("Phone: +91" + _textEditingController.text + " ");
                  if (_textEditingController.text.length == 10)
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => FirebasePhoneAuth(
                            "+91" + _textEditingController.text)));
                },
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
