import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

// ignore: must_be_immutable
class ProgressButton extends StatefulWidget {
  Color primaryColor = Colors.blueAccent,
      errorColor = Colors.redAccent,
      successColor = Colors.greenAccent,
      presentColor = Colors.blueAccent;

  double width, height, elevation = 5.0, borderRadius = 5.0;

  Future<int> onPressed;

  Widget child;

  TextStyle style = TextStyle(color: Colors.white, fontSize: 18.0);

  ProgressButton(
      {this.primaryColor,
      this.errorColor,
      this.successColor,
      this.width,
      this.height,
      this.onPressed,
      this.elevation,
      this.borderRadius}) {
    assert(this.primaryColor != null);
    assert(this.errorColor != null);
    assert(this.successColor != null);
    assert(this.width != null);
    assert(this.height != null);
    if(this.borderRadius == null)
      this.borderRadius = 8.0;
    if(this.elevation == null)
      this.elevation = 8.0;
    child = Text('Submit', style: style);
  }

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  @override
  Widget build(BuildContext context) {

    onButtonPressed() async {
      setState(() {
        widget.presentColor = widget.primaryColor;
        print('state set to circular progress indicator');
        widget.child = CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
      });

      int result = await widget.onPressed;

      print(result);

      switch (result) {
        case 0:
          setState(() {
            widget.presentColor = widget.successColor;
            widget.child = Text('Success', style: widget.style);
          });
          break;
        case 1:
          setState(() {
            widget.presentColor = widget.errorColor;
            widget.child = Text('Error', style: widget.style);
          });
          break;
        case 2:
          setState(() {
            widget.presentColor = widget.primaryColor;
            widget.child = Text('Submit', style: widget.style);
          });
          break;
      }
    }

    Widget buttonChild = SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(child: widget.child),
    );

    if (Platform.isAndroid)
      return RaisedButton(
        onPressed: onButtonPressed,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Center(child: widget.child),
        ),
        color: widget.presentColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius)),
        elevation: widget.elevation,
      );
     else
      return CupertinoButton(
        onPressed: onButtonPressed,
        child: buttonChild,
        color: widget.presentColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      );
  }
}
/*

Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child:new ProgressButton(
              width: MediaQuery.of(context).size.width * 8 / 10,
              height: 50.0,
              onPressed: Future.delayed(Duration(seconds: 3)).then((val) {
                return 1;
              }),
              errorColor: Colors.red,
              primaryColor: Colors.blueAccent,
              successColor: Colors.greenAccent,
            ),
          ),

          Container(
            padding: EdgeInsets.all(20.0),
            child:new ProgressButton(
              width: MediaQuery.of(context).size.width * 8 / 10,
              height: 50.0,
              onPressed: Future.delayed(Duration(seconds: 3)).then((val) {
                return 0;
              }),
              errorColor: Colors.red,
              primaryColor: Colors.blueAccent,
              successColor: Colors.greenAccent,
            ),
          ),

          Container(
            padding: EdgeInsets.all(20.0),
            child:new ProgressButton(
              width: MediaQuery.of(context).size.width * 8 / 10,
              height: 50.0,
              onPressed: Future.delayed(Duration(seconds: 3)).then((val) {
                return 2;
              }),
              errorColor: Colors.red,
              primaryColor: Colors.blueAccent,
              successColor: Colors.greenAccent,
            ),
          ),
        ],
      )

 */