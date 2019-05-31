import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_food/widgets/custom_navbar.dart';
import 'package:one_food/widgets/custom_icons_icons.dart';
import 'package:one_food/session/session_data.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget buildStack() {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 100.0,
            left: 0.0,
            right: 0.0,
            child: Text(
              '${SessionData.userPosition.localAddress} ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            )),
        Positioned(
            top: 55.0,
            right: 45.0,
            child: SizedBox(
              height: 70.0,
              child: Opacity(
                opacity: .5,
                child: Image.asset('assets/a/breakfast.png'),
              ),
            )),
        Positioned(
            top: 90.0,
            left: 45.0,
            child: SizedBox(
                height: 70.0,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/a/drinks.png'),
                ))),
        Positioned(
            top: 180.0,
            right: 75.0,
            child: SizedBox(
                height: 120.0,
                child: Opacity(
                    opacity: 0.4, child: Image.asset('assets/a/chicken.png')))),
        Positioned(
            bottom: 180.0,
            right: 120.0,
            child: SizedBox(
                height: 65.0,
                child: Opacity(
                    opacity: 0.4, child: Image.asset('assets/a/cupcake.png')))),
        Positioned(
            bottom: 250.0,
            left: 60.0,
            child: SizedBox(
                height: 70.0,
                child: Opacity(
                    opacity: 0.4, child: Image.asset('assets/a/food.png')))),
        Positioned(
            bottom: 100.0,
            left: 80.0,
            child: SizedBox(
                height: 60.0,
                child: Opacity(
                    opacity: 0.4, child: Image.asset('assets/a/pizza.png')))),
//        Positioned(child: SizedBox(height: 50.0,child: Image.asset('assets/a/salad.png'))),
//        Positioned(child: SizedBox(height: 50.0,child: Image.asset('assets/a/sandwich.png'))),
      ],
    );
  }

  Widget _getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50.0,
          right: 0.0,
          left: 0.0,
          child: Card(
            color: Colors.white,
            elevation: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                _getIcon('Breakfast', 'assets/a/breakfast.png'),
                _getIcon('Soft Drinks', 'assets/a/drinks.png'),
                _getIcon('Lunch', 'assets/a/food.png'),
                _getIcon('Pizza', 'assets/a/pizza.png'),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getIcon(String title, String asset) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              width: 50.0,
              child: Image.asset(asset),
            ),
            SizedBox(height: 5.0),
            Text(title)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _getBody(),
      bottomNavigationBar: CustomNavBar(
        iconSize: 27.0,
        selectedColor: Colors.greenAccent,
        selectedIndex: 0,
        unSelectedColor: Colors.grey,
        items: [
          CustomNavBarItem(Icons.home, 'Home'),
          CustomNavBarItem(CustomIcons.popularity, 'Popular'),
          CustomNavBarItem(CustomIcons.search, 'Search'),
          CustomNavBarItem(CustomIcons.cart, 'Cart'),
          CustomNavBarItem(Icons.account_circle, 'Account'),
        ],
        onChanged: (int index) {
          print(index);
        },
      ),
    );
  }
}
//[{"event":"app.progress","params":{"appId":"b17d8883-f288-4762-b3f3-e66f1245822d","id":"1","progressId":null,"message":"Resolving dependencies..."}}]
