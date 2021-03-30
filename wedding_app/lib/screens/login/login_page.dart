import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/widget_key.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPass = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener(
      cubit: _loginBloc,
      listener: (context, state) {
        if (state.isSubmitting) {
          FocusScope.of(context).unfocus();
          showProcessingSnackbar(context, state.message);
        }
        if (state.isSuccess) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showSuccessSnackbar(context, state.message);
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          });
        }
        if (state.isFailure) {
          FocusScope.of(context).unfocus();
          showSuccessAlertDialog(context, "Có lỗi", state.message, () {
            Navigator.pop(context);
          });
        }
      },
      child: SingleChildScrollView(
        child: BlocBuilder(
            cubit: _loginBloc,
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 30),
                      child: Container(
                        child: Image(
                            image: AssetImage(
                                'assets/app_icon/favicon-32x32.png')),
                        width: 70,
                        height: 70,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        "Đăng nhập để bắt đầu thực hiện đám cưới của bạn nào.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          key: Key(WidgetKey.loginEmailTextFieldKey),
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'E-mail',
                              errorText: !state.isEmailValid
                                  ? "Email không hợp lệ "
                                  : null,
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          TextField(
                            key: Key(WidgetKey.loginPasswordTextFieldKey),
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                            key: Key(WidgetKey.loginShowPasswordButtonKey),
                            onTap: onToggleShowPass,
                            child: Text(
                              _showPass ? "Ẩn Mật khẩu" : "Hiện Mật Khẩu",
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
                          key: Key(WidgetKey.loginButtonKey),
                          style: ElevatedButton.styleFrom(
                            primary: isLoginButtonEnabled(state)
                                ? hexToColor("#d86a77")
                                : Colors.grey,
                          ),
                          onPressed: () => isLoginButtonEnabled(state)
                              ? _onFormSubmitted()
                              : null,
                          child: Text(
                            'Đăng Nhập ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Container(
                        height: 20,
                        width: double.infinity,
                        child: new InkWell(
                          key: Key(WidgetKey.toRegisterPageButtonKey),
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Chưa có tài khoản? Đăng Kí ngay',
                                style: TextStyle(
                                    color: hexToColor("#d86a77"), fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        height: 20,
                        width: double.infinity,
                        child: InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, "/reset_password"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Quên Mật Khẩu?",
                                style: TextStyle(
                                    fontSize: 15, color: hexToColor("#d86a77")),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    ));
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void onLogInFacebookClick() {}
  void onLogInGoogleClick() {
    _loginBloc.add(
      LoginWithGooglePressed(),
    );
  }
}
