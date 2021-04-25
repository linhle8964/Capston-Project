
import 'package:flutter/material.dart';

void navigatorPop(int number, BuildContext context){
  int count = 0;
  Navigator.popUntil(context, (route) {
    return count++ == number;
  });
}