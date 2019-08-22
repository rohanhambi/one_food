import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_food/ui/my_account.dart';
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

  int pos = 3;

  double _height, _width;

  Widget _getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50.0,
          right: 0.0,
          left: 0.0,
          child: Card(
            color: Colors.white,
            elevation: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 20.0),
                    Text('Browse by shops nearby',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: _height * .29 / 10)),
                  ],
                ),
                SizedBox(height: 10.0),
                Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    _getIcon('Restaurant', 'assets/a/restaurant.png'),
                    _getIcon('Hotel', 'assets/a/hotel.png'),
                    _getIcon('Bakery', 'assets/a/bakers.png'),
                    _getIcon('Sweet home', 'assets/a/sweets.png'),
                    _getIcon('Ice cream', 'assets/a/icecream.png'),
                    _getIcon('Soft drinks', 'assets/a/softdrinks.png'),
                    _getIcon('Pizza', 'assets/a/deserts.png'),
                    _getIcon('Others', 'assets/a/breakfast.png'),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getIcon(String title, String asset) {
    return Container(
        height: _height * 1.2 / 10,
        width: _width * 2 / 10,
        margin: EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: _height * 0.62 / 10,
              width: _height * 0.62 / 10,
              child: Image.asset(asset),
            ),
            SizedBox(height: 3.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.green, fontSize: _height * 0.17 / 10),
            )
          ],
        ));
  }

  Widget _getAppbar() {
    return PreferredSize(
        child: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(width: 15.0),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Hello',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Username',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.location_on),
                  label: Text('Armur', style: TextStyle(fontSize: 18.0))),
              SizedBox(width: 20.0),
            ],
          ),
        ),
        preferredSize: Size(_width, 50.0));
  }

  Widget _whatToShow(){
    switch(pos){
      case 0: return Scaffold(appBar: _getAppbar(), body: _getBody());
      case 3: return MyAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _whatToShow(),
      bottomNavigationBar: CustomNavBar(
        iconSize: 27.0,
        selectedColor: Colors.greenAccent,
        selectedIndex: 0,
        unSelectedColor: Colors.grey,
        showTitle: false,
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
