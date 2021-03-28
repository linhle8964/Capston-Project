import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/register/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _showPass = false;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();

  RegisterBloc _registerBloc;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener(
          cubit: _registerBloc,
          listener: (BuildContext context, RegisterState state) {
            if (state.isSubmitting) {
              FocusScope.of(context).unfocus();
              showProcessingSnackbar(context, state.message);
            }
            if (state.isSuccess) {
              FocusScope.of(context).unfocus();
              showSuccessAlertDialog(context, "Thành công", state.message, () {
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
              });
            }
            if (state.isFailure) {
              FocusScope.of(context).unfocus();
              showSuccessAlertDialog(context, "Có lỗi", state.message, () {
                Navigator.pop(context);
              });
            }
          },
          child: BlocBuilder(
              cubit: _registerBloc,
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                              child: Container(
                                child: FlutterLogo(),
                                width: 70,
                                height: 70,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffd8d8d8)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                "Đăng ký để bắt đầu thực hiện đám cưới của bạn nào.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      labelText: 'E-mail',
                                      errorText: !state.isEmailValid
                                          ? "Email không hợp lệ "
                                          : null,
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Stack(
                                alignment: AlignmentDirectional.centerEnd,
                                children: <Widget>[
                                  TextField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _passController,
                                    obscureText: !_showPass,
                                    decoration: InputDecoration(
                                        labelText: 'Mật khẩu',
                                        errorText: !state.isPasswordValid
                                            ? "Mật khẩu không hợp lệ"
                                            : null,
                                        labelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                  ),
                                  GestureDetector(
                                    onTap: onToggleShowPass,
                                    child: Text(
                                      _showPass
                                          ? "Ẩn Mật khẩu"
                                          : "Hiện Mật Khẩu",
                                      style: TextStyle(
                                          color: hexToColor("#d86a77"),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: isRegisterButtonEnabled(state)
                                        ? hexToColor("#d86a77")
                                        : Colors.grey,
                                  ),
                                  onPressed: () =>
                                      isRegisterButtonEnabled(state)
                                          ? _onFormSubmitted()
                                          : null,
                                  child: Text(
                                    'Đăng Kí ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 30,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Đã có tài khoản? Đăng Nhập ngay',
                                        style: TextStyle(
                                            color: hexToColor("#d86a77"),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passController.text,
      ),
    );
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
