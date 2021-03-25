import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/guests/guests_bloc.dart';
import 'package:wedding_app/bloc/notification/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/screens/choose_template_invitation/chooseTemplate_page.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/screens/home/notification_button.dart';
import 'package:wedding_app/screens/notification/notification.dart';
import 'package:wedding_app/utils/count_home_item.dart';
import 'package:wedding_app/utils/format_number.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/widgets/notification.dart';
import 'button_column.dart';
import 'info_column.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

showprint() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String weddingID = prefs.getString("wedding_id");
  //print("CALLING ALARM");
  await Firebase.initializeApp();
  NotificationManagement.executeAlarm(weddingID);
}

class _HomePageState extends State<HomePage> {
  final Color main_color = Colors.black;
  int endTime = DateTime(2021, 3, 1, 7, 30, 00).millisecondsSinceEpoch;

  @override
  Future<void> initState() {
    super.initState();
    AndroidAlarmManager.periodic(Duration(seconds: 3), 0, showprint);
  }

  void onTime() {
    print('Married');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserWedding(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final UserWedding userWedding = snapshot.data;
          BlocProvider.of<WeddingBloc>(context)
              .add(LoadWeddingById(userWedding.weddingId));
          return BlocProvider(
            create: (BuildContext context) => NotificationBloc(
            notificationRepository: NotificationFirebaseRepository(),
          )..add(LoadNotifications(userWedding.weddingId)),
            child: Builder(
              builder: (context) =>BlocListener(
                cubit: BlocProvider.of<NotificationBloc>(context),
                listener: (context, state){
                  if (state is NewNotificationsUpdated) {
                    BlocProvider.of<NotificationBloc>(context)..add(LoadNotifications(userWedding.weddingId));
                    print("updated");
                  }
                },
                child: Builder(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Cung hỉ'),
                      centerTitle: true,
                      backgroundColor: hexToColor("#d86a77"),
                    ),
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      minimum: const EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: SingleChildScrollView(
                        child: BlocBuilder(
                          cubit: BlocProvider.of<WeddingBloc>(context),
                          builder: (context, state) {
                            if (state is WeddingLoaded) {
                              Wedding wedding = state.wedding;
                              BlocProvider.of<BudgetBloc>(context)
                                  .add(GetAllBudget(wedding.id));
                              BlocProvider.of<ChecklistBloc>(context)
                                  .add(LoadSuccess(wedding.id));
                              BlocProvider.of<GuestsBloc>(context)
                                  .add(LoadGuests(wedding.id));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/image/home_top.jpg'),
                                          fit: BoxFit.cover),
                                    ),
                                    height: 180,
                                    alignment: Alignment.center,
                                    child: CountdownTimer(
                                      endTime:
                                          wedding.weddingDate.millisecondsSinceEpoch,
                                      widgetBuilder: (_, CurrentRemainingTime time) {
                                        if (time == null) {
                                          return Text(
                                            'Chúc 2 bạn hạnh phúc',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          );
                                        }
                                        return Text(
                                          ' ${(time.days == null) ? '' : (time.days.toString() + ' ngày,')}  ${(time.hours == null) ? '0' : time.hours} :  ${(time.min == null) ? '0' : time.min} : ${time.sec}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              isAdmin(userWedding.role)
                                                  ? TextButton(
                                                      style: TextButton.styleFrom(
                                                          primary: Colors.black),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(5),
                                                        child: Text(
                                                          'Chia sẻ quyền quản lý',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: main_color,
                                                                width: 2)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(context,
                                                            "/invite_collaborator");
                                                      },
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildButtonColumn(Colors.blue,
                                            Icons.add_rounded, 'KHÁCH MỜI', () {}),
                                        buildButtonColumn(
                                          Colors.pink[400],
                                          Icons.assignment_ind_outlined,
                                          'THIỆP MỜI',
                                          () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChooseTemplatePage(
                                                        isCreate: false,
                                                      )),
                                            );
                                          },
                                        ),
                                        Builder(
                                          builder: (context) => BlocBuilder(
                                            cubit: BlocProvider.of<NotificationBloc>(context),
                                            builder: (context, state) {
                                              int number =0;
                                              if(state is NotificationsLoaded){
                                                List<NotificationModel> notifications = state.notifications;
                                                if(notifications!= null){
                                                    for(int i=0; i<notifications.length;i++){
                                                      if(notifications[i].isNew) number++;
                                                    }
                                                  }
                                              }
                                              print(number);
                                              return NotificationIcon(color: Colors.green,
                                                function: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => BlocProvider.value(
                                                            value: BlocProvider.of<NotificationBloc>(context),
                                                            child: NotificationPage(weddingID: wedding.id,))),
                                                  );
                                                },
                                                icon: Icons.add_alarm, label: 'THÔNG BÁO', number: number);}
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  BlocBuilder(
                                    cubit: BlocProvider.of<ChecklistBloc>(context),
                                    builder: (context, state) {
                                      if (state is TasksLoaded) {
                                        return Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildInfoColumn(
                                                  context,
                                                  main_color,
                                                  'Việc cần làm ',
                                                  state.tasks.isEmpty
                                                      ? "0"
                                                      : state.tasks.length
                                                          .toString()),
                                              buildInfoColumn(
                                                  context,
                                                  main_color,
                                                  'Việc đã xong ',
                                                  state.tasks.isEmpty
                                                      ? "0"
                                                      : countFinisedTask(state.tasks)
                                                          .toString()),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  BlocBuilder(
                                    cubit: BlocProvider.of<BudgetBloc>(context),
                                    builder: (context, state) {
                                      if (state is BudgetLoaded) {
                                        return Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildInfoColumn(
                                                  context,
                                                  main_color,
                                                  'Tổng ngân sách ',
                                                  formatNumber(wedding.budget
                                                      .toInt()
                                                      .toString())),
                                              buildInfoColumn(
                                                  context,
                                                  main_color,
                                                  'Đã dùng ',
                                                  state.budgets.length == 0
                                                      ? "0"
                                                      : formatNumber(
                                                          countBudget(state.budgets)
                                                              .toString())),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  BlocBuilder(
                                    cubit: BlocProvider.of<GuestsBloc>(context),
                                    builder: (context, state) {
                                      if (state is GuestsLoaded) {
                                        return Container(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildInfoColumn(
                                                  context,
                                                  main_color,
                                                  'Số khách dự kiến ',
                                                  state.guests.isEmpty
                                                      ? "0"
                                                      : state.guests.length
                                                          .toString()),
                                              buildInfoColumn(
                                                  context,
                                                  main_color,
                                                  'Khách đã xác nhận ',
                                                  state.guests.isEmpty
                                                      ? "0"
                                                      : countConfirmedGuest(
                                                              state.guests)
                                                          .toString()),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Container(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
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
    //nang added
  }
}
