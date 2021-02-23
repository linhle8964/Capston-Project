import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';

class DropDown extends StatefulWidget {
  String dropdownValue;
  DropDown({Key key,@required this.dropdownValue}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownState extends State<DropDown> {

  CateBloc _cateBloc;

  @override
  void initState() {
    super.initState();
    _cateBloc = BlocProvider.of<CateBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cateBloc,
      builder: (context, state) {
        List<String> categories = [];
        List<Category> categoryObjects = [];
        if (state is TodosLoaded) {
          categoryObjects = state.cates;
          for (int i = 0; i < categoryObjects.length; i++) {
            categories.add(categoryObjects[i].name.toString());
          }
           // widget.dropdownValue = categories.length !=0? categories[0].toString()
           //    : widget.dropdownValue;
        } else if (state is TodosLoading) {}
        else if (state is TodosNotLoaded) {}
        return DropdownButton<String>(
          isExpanded: true,
          value: widget.dropdownValue,
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: 40,
          elevation: 16,
          onChanged: (String newValue) {
            setState(() {
              widget.dropdownValue = newValue;
            });
          },
          items: categories.map<DropdownMenuItem<String>>((String value) {
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
