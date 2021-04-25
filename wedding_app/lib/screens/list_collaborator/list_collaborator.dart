import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/utils/format_date.dart';
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
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: state.userWeddings.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.people),
                    title: Text(
                      state.userWeddings[index].email,
                      style: TextStyle(fontSize: 15.0),
                    ),
                    subtitle: Text("Ngày gia nhập: " +
                      convertDateTimeDDMMYYYY(
                          state.userWeddings[index].joinDate),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    trailing: Text(
                      convertRoleFromDb(state.userWeddings[index].role),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                );
              },
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
