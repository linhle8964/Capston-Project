import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/invite_email/bloc.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

class WeddingCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final TextEditingController _codeController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Nhập mã mời'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<InviteEmailBloc, InviteEmailState>(
            listener: (context, state) {
              if (state is InviteEmailProcessing) {
                showProcessingSnackbar(context, "Đang xử lý dữ liệu");
              } else if (state is InviteEmailError) {
                showFailedSnackbar(context, state.message);
              } else if (state is InviteEmailSuccess) {
                showSuccessSnackbar(context, state.message);
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              }
            },
          )
        ],
        child: SizedBox.expand(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width / 3,
                child: TextFormField(
                  controller: _codeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  decoration: InputDecoration(
                      hintText: 'Nhập mã mời',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              ButtonTheme(
                  minWidth: width / 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  child: RaisedButton(
                      child: Text("Gửi mã",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      color: hexToColor("#d86a77"),
                      onPressed: () {
                        BlocProvider.of<InviteEmailBloc>(context).add(
                            SubmittedCode(_codeController.text.toString()));
                      }))
            ],
          ),
        )),
      ),
    );
  }
}
