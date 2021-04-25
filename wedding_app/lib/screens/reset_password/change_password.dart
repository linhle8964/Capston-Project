import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wedding_app/bloc/change_password/bloc.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:wedding_app/widgets/input_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/widgets/navigator_pop.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordBloc _changePasswordBloc;
  TextEditingController _oldPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _repeatPasswordController = new TextEditingController();

  bool get isPopulated =>
      _oldPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _repeatPasswordController.text.isNotEmpty;

  bool isChangePasswordButtonEnabled(ChangePasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);
    _oldPasswordController.addListener(() => _changePasswordBloc
        .add(OldPasswordChanged(oldPassword: _oldPasswordController.text)));
    _newPasswordController.addListener(() => _changePasswordBloc
        .add(NewPasswordChanged(newPassword: _newPasswordController.text)));
    _repeatPasswordController.addListener(() => _changePasswordBloc.add(
        RepeatPasswordChanged(repeatPassword: _repeatPasswordController.text)));
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text(
          "Thay đổi mật khẩu",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocListener(
        cubit: _changePasswordBloc,
        listener: (context, state) {
          if (state.isSubmitting) {
            FocusScope.of(context).unfocus();
            showProcessingSnackbar(context, state.message);
          }
          if (state.isSuccess) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar();
            showSuccessAlertDialog(
                context, MessageConst.dialogTitle, state.message, () {
              navigatorPop(2, context);
            });
          }
          if (state.isFailure) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar();
            showErrorAlertDialog(
                context, MessageConst.commonErrorTitle, state.message, () {
              Navigator.pop(context);
            });
          }
        },
        child: SingleChildScrollView(
          child: BlocBuilder(
            cubit: _changePasswordBloc,
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      height: height / 8,
                      child: InputFieldArea(
                        controller: _oldPasswordController,
                        labelText: "Mật khẩu cũ",
                        icon: Icon(Icons.remove_red_eye),
                        obscure: true,
                        errorText: !state.isOldPasswordValid
                            ? state.oldPasswordErrorMessage
                            : null,
                        isPassword: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      height: height / 8,
                      child: InputFieldArea(
                        controller: _newPasswordController,
                        labelText: "Mật khẩu mới",
                        icon: Icon(Icons.remove_red_eye),
                        obscure: true,
                        errorText: !state.isNewPasswordValid
                            ? state.newPasswordErrorMessage
                            : null,
                        isPassword: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      height: height / 8,
                      child: InputFieldArea(
                        controller: _repeatPasswordController,
                        labelText: "Nhập lại mật khẩu",
                        icon: Icon(Icons.remove_red_eye_sharp),
                        obscure: true,
                        errorText: !state.isRepeatPasswordValid
                            ? state.repeatPasswordErrorMessage
                            : null,
                        isPassword: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                          child: Text("Thay đổi"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isChangePasswordButtonEnabled(state)
                                    ? hexToColor("#d86a77")
                                    : Colors.grey),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey))),
                          ),
                          onPressed: () => isChangePasswordButtonEnabled(state)
                              ? _onSubmitted()
                              : null,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSubmitted() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) => PersonDetailsDialog(
              message: MessageConst.changePasswordConfirm,
              onPressedFunction: () async {
                _changePasswordBloc.add(ChangePasswordSubmitted(
                    oldPassword: _oldPasswordController.text,
                    newPassword: _newPasswordController.text,
                    repeatPassword: _repeatPasswordController.text));
              },
            ));
  }
}
