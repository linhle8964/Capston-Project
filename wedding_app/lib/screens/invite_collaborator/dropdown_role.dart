import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(String role);

class RoleDropdown extends StatefulWidget {
  final OnSaveCallback onSave;
  RoleDropdown({Key key, @required this.onSave}) : super(key: key);

  @override
  _RoleDropdownState createState() => _RoleDropdownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RoleDropdownState extends State<RoleDropdown> {
  String dropdownValue = 'Admin';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: 40,
          elevation: 16,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              widget.onSave(dropdownValue.trim());
            });
          },
          items: <String>['Admin', 'Editor']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
