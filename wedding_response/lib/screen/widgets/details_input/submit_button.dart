import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/guests/bloc.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/screen/views/success/success_page.dart';
import 'package:flutter_web_diary/util/confirm_dialog.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';

class SubmitButtonCustom extends StatelessWidget {
  String weddingID;
  GlobalKey<FormState> formKey;
  ValueChanged<bool> onTapped;
  bool isUpdated;

  SubmitButtonCustom(
      {Key key, @required this.onTapped, @required this.formKey, @required this.weddingID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
        builder: (ctx) => IconButton(
          icon: Icon(
            Icons.input, color: Colors.red,
          ),
          onPressed: () {
            _sendResponse(ctx);
          },
          iconSize: 40,
        ),
      ),
    );
  }

  _sendResponse(var ctx) {
    final FormState form = formKey.currentState;
    form.save();
    if (form.validate()) {
      //_showDialog(context);
      showDialog(
          context: ctx,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              PersonDetailsDialog(
                message: "Bạn đang phản hồi lời mời đám cưới",
                onPressedFunction: () {
                  if(guestToUpdate.status!= 1) guestToUpdate.companion=0;
                  BlocProvider.of<GuestsBloc>(ctx)
                    ..add(UpdateGuest(guestToUpdate, weddingID));
                  isUpdated = true;
                  onTapped(true);
                },
              ));
    }
  }
}
