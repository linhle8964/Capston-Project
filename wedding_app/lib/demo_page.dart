import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeddingFromSharePreferences(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Wedding wedding = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: hexToColor("#d86a77"),
              title: Text('Home'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      LoggedOut(),
                    );
                  },
                )
              ],
            ),
            body: BlocBuilder(
              cubit: BlocProvider.of<AuthenticationBloc>(context),
              builder: (context, state) {
                if (state is Uninitialized) {
                  return LoadingIndicator();
                } else if (state is Authenticated) {
                  BlocProvider.of<WeddingBloc>(context)
                      .add(LoadWeddingByUser(state.user));
                  return BlocBuilder(
                    cubit: BlocProvider.of<WeddingBloc>(context),
                    builder: (context, state) {
                      if (state is WeddingLoaded) {
                        return Column(
                          children: [
                            Text(wedding.dateCreated.toString()),
                          ],
                        );
                      } else if (state is Loading) {
                        return LoadingIndicator();
                      } else if (state is Failed) {}
                      return LoadingIndicator();
                    },
                  );
                }
                return LoadingIndicator();
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
