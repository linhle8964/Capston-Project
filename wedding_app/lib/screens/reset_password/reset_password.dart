import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/reset_password/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = new TextEditingController();
  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isRegisterButtonEnabled(ResetPasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        cubit: BlocProvider.of<ResetPasswordBloc>(context),
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
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [TextField()],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
