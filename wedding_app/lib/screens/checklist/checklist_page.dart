import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/bloc/show_task/bloc.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/screens/checklist/download_excel.dart';
import 'package:wedding_app/screens/edit_task/edit_task.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/firebase_repository/category_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/add_task/add_task.dart';
import 'package:wedding_app/screens/checklist/listview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_page/search_page.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

class ChecklistPage extends StatefulWidget {
  final UserWedding userWedding;

  ChecklistPage({Key key, @required this.userWedding}) : super(key: key);
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  List<DateTime> months = [];
  List<Task> valuess = []; // show by month
  List<Task> tasks = []; // all
  List<Task> searchList = []; // searching

  TextEditingController _searchQuery = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = CrossAxisAlignment.center;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text(
              'CÔNG VIỆC',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(context) {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Tìm kiếm',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }

  List<Widget> _buildActions(context, String weddingID) {
    return <Widget>[
      new IconButton(
        icon: Icon(Icons.arrow_downward),
        onPressed: () {
          showMyAlertDialog(context);
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          showSearch(
              context: context,
              delegate: SearchPage<Task>(
                searchLabel: "Tìm Kiếm",
                barTheme: ThemeData(
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white70, fontSize: 18),
                  ),
                  appBarTheme: AppBarTheme(
                      elevation: 0.0,
                      color: hexToColor("#d86a77")), //elevation did work
                ),
                suggestion: Center(
                  child: Text(
                    'Tìm kiếm theo tên công việc',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                failure: Center(
                  child: Text(
                    'Chưa có công việc tìm thấy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                builder: (Task task) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<CateBloc>(context),
                                  child: BlocProvider.value(
                                      value: BlocProvider.of<ChecklistBloc>(
                                          context),
                                      child: EditTaskPage(
                                          task: task, weddingID: weddingID)),
                                )),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          task.name,
                          key: UniqueKey(),
                          style: TextStyle(
                            fontSize: 17,
                            color: task.dueDate.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                    )),
                filter: (Task task) => [task.name],
                items: tasks,
              ));
        },
      ),
    ];
  }

  showMyAlertDialog(BuildContext context) {
    GlobalKey _containerKey = GlobalKey();
    // Create AlertDialog
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content:
          Text("Bạn có muốn lưu lại danh sách công việc dưới dạng file excel?"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
            child: Text("Có",style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
              downloadFile(tasks, context);
            }),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: hexToColor("#d86a77"),
            ),
            child: Text("Không",style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    final String weddingID = widget.userWedding.weddingId;
    return MultiBlocProvider(
      providers: [
        BlocProvider<CateBloc>(
          create: (BuildContext context) => CateBloc(
            todosRepository: FirebaseCategoryRepository(),
          )..add(LoadTodos()),
        ),
        BlocProvider<ChecklistBloc>(create: (BuildContext context) {
          return ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
            notificationRepository: NotificationFirebaseRepository(),
          )..add(LoadSuccess(weddingID));
        }),
        BlocProvider<ShowTaskBloc>(
          create: (BuildContext context) => ShowTaskBloc(number1: 0),
        ),
      ],
      child: Builder(
        builder: (context) => BlocListener(
          cubit: BlocProvider.of<ChecklistBloc>(context),
          listener: (context, state) {
            if (state is TaskDeleted) {
              print("delete");
              BlocProvider.of<ShowTaskBloc>(context)..add(DeleteMonth());
              BlocProvider.of<ChecklistBloc>(context)
                ..add(LoadSuccess(weddingID));
              showSuccessSnackbar(context, "bạn đã xóa thành công");
            } else if (state is TaskAdded) {
              BlocProvider.of<ChecklistBloc>(context)
                ..add(LoadSuccess(weddingID));
              showSuccessSnackbar(context, "bạn đã thêm thành công");
            } else if (state is TaskUpdated) {
              BlocProvider.of<ChecklistBloc>(context)
                ..add(LoadSuccess(weddingID));
              showSuccessSnackbar(context, "bạn đã chỉnh sửa thành công");
            }
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: hexToColor("#d86a77"),
              title: _buildTitle(context),
              actions: _buildActions(context, weddingID),
            ),
            body: _body(weddingID),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CateBloc>(context),
                            child: BlocProvider.value(
                                value: BlocProvider.of<ChecklistBloc>(context),
                                child: AddTaskPage(weddingID: weddingID)),
                          )),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: hexToColor("#d86a77"),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }

  Widget _body(String weddingID) {
    return Builder(
      builder: (context) => BlocBuilder(
          cubit: BlocProvider.of<ChecklistBloc>(context),
          buildWhen: (previous, current) {
            if (current is TaskUpdated2) {
              return false;
            } else {
              return true;
            }
          },
          builder: (context, state) {
            if (state is TasksLoaded) {
              tasks.clear();
              months.clear();
              tasks = state.tasks;
              for (int i = 0; i < tasks.length; i++) {
                bool isExisted = false;
                for (int j = 0; j < i; j++) {
                  if (tasks[i].dueDate.month == tasks[j].dueDate.month &&
                      tasks[i].dueDate.year == tasks[j].dueDate.year) {
                    isExisted = true;
                    break;
                  }
                }
                if (isExisted == false) {
                  months.add(tasks[i].dueDate);
                }
                //add tasks to list according to months
              }
              if (tasks.length == 0) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Bạn chưa có công việc nào',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              } else
                return BlocBuilder(
                    cubit: BlocProvider.of<ShowTaskBloc>(context),
                    builder: (context, state) {
                      if (state is MonthLoading ||
                          state is MonthMovedPreviously ||
                          state is MonthMovedToNext ||
                          state is MonthDeleted) {
                        int month = months[state.number].month;
                        int year = months[state.number].year;
                        //add tasks to list by month
                        valuess.clear();
                        for (int i = 0; i < tasks.length; i++) {
                          if (tasks[i].dueDate.month == month &&
                              tasks[i].dueDate.year == year) {
                            valuess.add(tasks[i]);
                          }
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.black26,
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios_outlined,
                                        color: Colors.white),
                                    onPressed: () {
                                      BlocProvider.of<ShowTaskBloc>(context)
                                          .add(ShowPrevious());
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      'THÁNG $month, $year',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward_ios_outlined,
                                        color: Colors.white),
                                    onPressed: () {
                                      BlocProvider.of<ShowTaskBloc>(context)
                                          .add(ShowNext(months.length));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Chưa đến hạn",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Đã quá hạn",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 0, right: 15, left: 15, bottom: 50),
                                child: ListViewWidget(
                                    tasks: valuess, weddingID: weddingID),
                              ),
                            ),
                          ],
                        );
                      } else
                        return Text("có lỗi xảy ra");
                    });
            } else if (state is TasksLoading) {
              return Column(
                children: [
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
