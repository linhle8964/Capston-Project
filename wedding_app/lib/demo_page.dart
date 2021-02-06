import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Center(
        child: BlocBuilder(
          cubit: BlocProvider.of<AuthenticationBloc>(context),
          builder: (context, state) {
            if (state is Uninitialized) {
              return LoadingIndicator();
            } else if (state is Authenticated) {
              return Text(state.user.uid);
            }
            return LoadingIndicator();
          },
        ),
      ),
    );
  }
}
