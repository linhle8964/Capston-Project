import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:wedding_app/widgets/notification.dart';
import 'bloc/checklist/bloc.dart';
import 'bloc/checklist/checklist_bloc.dart';

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
      future: getWeddingID(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final String weddingID = snapshot.data;
          return MultiBlocProvider(
            providers: [
              BlocProvider<ChecklistBloc>(
                create: (BuildContext context) => ChecklistBloc(
                  taskRepository: FirebaseTaskRepository(),
                )..add(LoadSuccess(weddingID)),
              ),
            ],
            child: Builder(
              builder: (context) => BlocBuilder(
                cubit: BlocProvider.of<ChecklistBloc>(context),
                builder: (context, state) {
                  // Nang added
                  if (NotificationManagement.notificationTime.isEmpty) {
                    if (state is TasksLoaded) {
                      NotificationManagement.addExistingNotifications(
                          state.tasks);
                    }
                  }
                  //end
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
                            //NAng ADded
                            NotificationManagement.ClearAllNotifications();
                            //end
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
                                    Text(state.wedding.id),
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
                },
              ),
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
