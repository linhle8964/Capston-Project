import 'dart:ui';
import 'package:wedding_app/bloc/invite_email/bloc.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

import 'dropdown_role.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class InviteCollaboratorPage extends StatelessWidget {
  String role = "";
  void _submit(BuildContext context, String role) {
    print(role);
    String email = _emailController.text.toString();
    BlocProvider.of<InviteEmailBloc>(context)
        .add(SendEmailButtonSubmitted(email));
  }

  final TextEditingController _emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Mời cộng tác viên'),
      ),
      body: BlocListener(
        cubit: BlocProvider.of<InviteEmailBloc>(context),
        listener: (context, state) {
          if (state is InviteEmailProcessing) {
            showSnackbar(context, "Đang xử lý", false);
          } else if (state is InviteEmailError) {
            showSnackbar(context, state.message, true);
          } else if (state is InviteEmailSuccess) {
            FocusScope.of(context).unfocus();
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.message),
                      Icon(Icons.check),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
          }
        },
        child: BlocBuilder(
          cubit: BlocProvider.of<UserWeddingBloc>(context),
          builder: (context, state) {
            if (state is UserWeddingLoaded) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Danh sách người quản lí",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text("Quyền truy cập",
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.black,
                      thickness: 3.0,
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.userWeddings.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.userWeddings[index].email,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                state.userWeddings[index].role,
                                style: TextStyle(fontSize: 15.0),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Hãy nhập Email người mà bạn muốn mời cùng chỉnh sửa",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        hintText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: RoleDropdown(
                        onSave: (roleDropdown) {
                          role = roleDropdown;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: RaisedButton(
                          color: hexToColor("#d86a77"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          onPressed: () => _submit(context, role),
                          child: Text(
                            'Gửi lời mời ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserWeddingLoading) {
              return Center(child: Text("31231"));
            }
            return Center(child: LoadingIndicator());
          },
        ),
      ),
    );
  }
}
