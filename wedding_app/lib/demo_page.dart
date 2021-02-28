import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:wedding_app/widgets/notification.dart';
import 'bloc/checklist/bloc.dart';
import 'bloc/checklist/checklist_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String id = "";
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      String weddingId = prefs.getString("wedding_id");
      print("test shared " + weddingId);
      id = weddingId;
    });
  }



  @override
  Widget build(BuildContext context) {
    print("ID: $id");
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChecklistBloc>(
          create: (BuildContext context) => ChecklistBloc(
            weddingId: id,
            taskRepository: FirebaseTaskRepository(),
          )..add(LoadSuccess(id)),
        ),
      ],
      child: Builder(
        builder:(context) => BlocBuilder(
          cubit: BlocProvider.of<ChecklistBloc>(context),
          builder: (context,state) {
            // Nang added
            if(notificationTime.isEmpty){
              if(state is TasksLoaded){
                NotificationManagement.addExistingNotifications(state.tasks);
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
          );},
        ),
      ),
    );
  }
}
