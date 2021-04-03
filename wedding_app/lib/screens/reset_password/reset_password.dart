import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/reset_password/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = new TextEditingController();
  ResetPasswordBloc _resetPasswordBloc;
  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isRegisterButtonEnabled(ResetPasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _resetPasswordBloc = BlocProvider.of<ResetPasswordBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        cubit: _resetPasswordBloc,
        listener: (context, state) {
          if (state.isSubmitting) {
            FocusScope.of(context).unfocus();
            showProcessingSnackbar(context, state.message);
          } else if (state.isSuccess) {
            FocusScope.of(context).unfocus();
            showSuccessAlertDialog(context, "Thành công", state.message, () {
              int count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            });
          } else if (state.isFailure) {
            FocusScope.of(context).unfocus();
            showSuccessAlertDialog(context, "Có lỗi", state.message, () {
              Navigator.pop(context);
            });
          }
        },
        child: BlocBuilder(
          cubit: BlocProvider.of<ResetPasswordBloc>(context),
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        errorText:
                            !state.isEmailValid ? "Email không hợp lệ " : null,
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: isRegisterButtonEnabled(state)
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () => isRegisterButtonEnabled(state)
                              ? _onFormSubmitted()
                              : null,
                          child: Text(
                            'Thay đổi mật khẩu ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onEmailChanged() {
    _resetPasswordBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _resetPasswordBloc.add(Submitted(email: _emailController.text));
  }
}
