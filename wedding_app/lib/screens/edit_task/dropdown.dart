import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/model/category_model.dart';

class DropDown extends StatefulWidget {
  DropDown({Key key}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownState extends State<DropDown> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState){
        final List<Category> categoriyObjects = (categoryState as CategoryLoadSuccess).categories;
        final List<String> categories = [];
        for(int i=0; i< categoriyObjects.length; i++){
          categories.add(categoriyObjects[i].name.toString());
        }
          return DropdownButton<String>(
            isExpanded: true,
            value: categories[0]!=null? categories[0].toString() : null,
            icon: Icon(Icons.keyboard_arrow_down_outlined),
            iconSize: 40,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: categories
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
          );
      },
    );
  }
}
