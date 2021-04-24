import 'package:flutter/material.dart';
import 'package:wedding_app/const/message_const.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text(
            MessageConst.commonLoading,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }
}
