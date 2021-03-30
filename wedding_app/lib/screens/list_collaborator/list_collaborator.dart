import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/role_convert.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListCollaborator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Danh sách người quản lí'),
      ),
      body: BlocBuilder(
        cubit: BlocProvider.of<UserWeddingBloc>(context),
        builder: (context, state) {
          if (state is UserWeddingLoaded) {
            return Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                            style: TextStyle(fontSize: 20.0)),
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
                              convertRoleFromDb(state.userWeddings[index].role),
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is UserWeddingLoading) {
            return SplashPage();
          }
          return Center(child: LoadingIndicator());
        },
      ),
    );
  }
}
