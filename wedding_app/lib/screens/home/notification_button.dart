import 'package:flutter/material.dart';


class NotificationIcon extends StatefulWidget {
  Color color;
  IconData icon;
  String label;
  Function function;
  int number;

  NotificationIcon({Key key, @required this.color, @required this.function,@required this.icon, @required this.label, @required this.number})
      : super(key: key);
  @override
  _NotificationIconState createState() => _NotificationIconState();
}


class _NotificationIconState extends State<NotificationIcon> {

  @override
  void initState() {
    super.initState();
  }

  TextButton notificationIcon(Color color, IconData icon, String label, Function function, int number) {
    return TextButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(icon, color: color),
              position(color, icon, label, function, number),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      onPressed: function.call,
    );
  }

  Widget position(Color color, IconData icon, String label, Function function, int number){
    if(widget.number ==0){
      return Container();
    }else{
      return new Positioned(
        right: 0,
        child: new Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            minWidth: 13,
            minHeight: 13,
          ),
          child: new Text(
            number.toString(),
            style: new TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return notificationIcon(widget.color, widget.icon, widget.label, widget.function, widget.number);
  }
}