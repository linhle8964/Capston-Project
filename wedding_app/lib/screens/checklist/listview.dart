import 'package:flutter/material.dart';

class ListViewWidget extends StatefulWidget {
  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override

  Map<String, bool> values = {
    'Công việc thứ 2': false,
    'Công việc thứ 3': false,
    'Công việc thứ 4': false,
    'Công việc thứ 5': false,
    'Công việc thứ 6': false,
  };
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            values.keys.elementAt(index),
            key: UniqueKey(),
            style: TextStyle(
              fontSize:17,
            ),
          ),
          trailing: Checkbox(
            activeColor: Colors.lightBlue,
            value: values.values.elementAt(index),
            onChanged: (bool value) {
              setState(() {
                values[values.keys.elementAt(index)] = value;
              });
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(thickness: 2.0,);
      },
    );
  }
}
