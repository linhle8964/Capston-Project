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
  String dropdownValue = null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState){
        final List<Category> categoryObjects = (categoryState as CategoryLoadSuccess).categories;
        final List<String> categories = [];
        for(int i=0; i< categoryObjects.length; i++){
          categories.add(categoryObjects[i].name.toString());
          print(categories[i].toString()+" test");
        }
        print(categoryObjects.length);
          return DropdownButton<String>(
            isExpanded: true,
            value: categories[0]!=null? categories[0].toString(): dropdownValue,
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
