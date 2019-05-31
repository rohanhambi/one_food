import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomNavBar extends StatefulWidget {

  List<CustomNavBarItem> items;
  int selectedIndex = 0;
  Color selectedColor = Colors.blue, unSelectedColor = Colors.grey;
  double iconSize = 24.0;
  ValueChanged<int> onChanged;

  CustomNavBar(
      {@required this.items,
      @required this.selectedIndex,
      @required this.selectedColor,
      @required this.unSelectedColor,
      @required this.iconSize,this.onChanged}) {
    assert(items.length > 2);
  }

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {

  List<Widget> getButtons() {
    List<Widget> buttons = [];

    for (int i = 0; i < widget.items.length; i++) {
      if(i==widget.selectedIndex)
        buttons.add(
          Expanded(child: InkWell(
            splashColor: Colors.blueGrey.withOpacity(0.3),
            splashFactory: InkRipple.splashFactory,
            enableFeedback: true,
            highlightColor: Colors.transparent,
            child: Column(
              children: <Widget>[
                SizedBox(height: 3.0),
                Icon(
                  widget.items[i].icon,
                  color: widget.selectedColor,
                  size: widget.iconSize,
                  semanticLabel: widget.items[i].title,
                ),
                Text('${widget.items[i].title}',textAlign: TextAlign.center,style: TextStyle(color: widget.selectedColor),),
                SizedBox(height: 3.0)
              ],
            ),
            radius: widget.iconSize,
            onTap: (){
              if(widget.onChanged != null && widget.selectedIndex != i) {
                widget.onChanged(i);
                widget.selectedIndex = i;
                setState(() {});
              }
            },
          ),
          )
        );
      else
        buttons.add(
          Expanded(child: InkWell(
            splashColor: Colors.blueGrey.withOpacity(0.3),
            splashFactory: InkRipple.splashFactory,
            enableFeedback: true,
            highlightColor: Colors.transparent,
            child: Column(
            children: <Widget>[
              SizedBox(height: 3.0),
               Icon(
                  widget.items[i].icon,
                  color: widget.unSelectedColor,
                  size: widget.iconSize,
                  semanticLabel: widget.items[i].title,
                ),
              Text('${widget.items[i].title}',textAlign: TextAlign.center,style: TextStyle(color: widget.unSelectedColor),),
              SizedBox(height: 3.0)
            ],
          ),radius: widget.iconSize,
            onTap: (){
              if(widget.onChanged != null && widget.selectedIndex != i) {
                widget.onChanged(i);
                widget.selectedIndex = i;
                setState(() {});
              }
            },
          ),)
        );
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      child: SizedBox(
        height: 50.0,
        child: Row(
          children: getButtons(),
        ),
      ),
    );
  }
}

class CustomNavBarItem  {

  IconData icon;
  String title;

  CustomNavBarItem(this.icon,this.title);

}


/*

Expanded(
              flex: 1,
                child: CustomNavBarItem(isSelected: true, icon: Icons.home,
            toolTip: 'Home', selected: Colors.blue, unSelected: Colors.grey, onPressed: (){
                  print('home tapped');
                    }, iconSize: 28.0,)),

            Expanded(
                flex: 1,
                child: CustomNavBarItem(isSelected: false, icon: Icons.add,
                  toolTip: 'Home', selected: Colors.blue, unSelected: Colors.grey, onPressed: (){
                    print('home tapped');
                  }, iconSize: 28.0,)),

            Expanded(
                flex: 1,
                child: CustomNavBarItem(isSelected: false, icon: Icons.account_circle,
                  toolTip: 'Home', selected: Colors.blue, unSelected: Colors.grey, onPressed: (){
                    print('home tapped');
                  }, iconSize: 28.0,)),

            Expanded(
                flex: 1,
                child: CustomNavBarItem(isSelected: false, icon: Icons.home,
                  toolTip: 'Home', selected: Colors.blue, unSelected: Colors.grey, onPressed: (){
                    print('home tapped');
                  }, iconSize: 28.0,)),
 */

