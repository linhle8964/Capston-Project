import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/bloc/show_task/bloc.dart';
import 'package:wedding_app/firebase_repository/category_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/add_task/add_task.dart';
import 'package:wedding_app/screens/checklist/listview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class ChecklistPage extends StatefulWidget {
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

  TextEditingController _searchQuery;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
    });
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
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Tìm kiếm',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.grey, fontSize: 16.0),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.grey,
          ),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CateBloc>(
          create: (BuildContext context) => CateBloc(
            todosRepository: FirebaseCategoryRepository(),
          )..add(LoadTodos()),
        ),
        BlocProvider<ChecklistBloc>(
          create: (BuildContext context) => ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
          )..add(LoadSuccess()),
        ),
        BlocProvider<ShowTaskBloc>(
          create: (BuildContext context) => ShowTaskBloc(number1: 0),
        ),
      ],
      child: Builder(
        builder: (context) => BlocListener(
          cubit: BlocProvider.of<ChecklistBloc>(context),
          listener: (context, state) {
            if (state is TaskDeleted) {
              BlocProvider.of<ChecklistBloc>(context)..add(LoadSuccess());
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("bạn đã xóa thành công")));
            } else if (state is TaskAdded) {
              BlocProvider.of<ChecklistBloc>(context)..add(LoadSuccess());
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("bạn đã thêm thành công")));
            } else if (state is TaskUpdated) {
              BlocProvider.of<ChecklistBloc>(context)..add(LoadSuccess());
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("bạn đã chỉnh sửa thành công")));
            }
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              leading:
                  _isSearching ? const BackButton(
                      color: Colors.grey,
                      onPressed: null,
                  ) : null,
              title: _isSearching ? _buildSearchField() : _buildTitle(context),
              actions: _buildActions(),
            ),
            body: _body(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CateBloc>(context),
                            child: BlocProvider.value(
                                value: BlocProvider.of<ChecklistBloc>(context),
                                child: AddTaskPage()),
                          )),
                );
              },
              label: Text('thêm công việc'),
              icon: Icon(Icons.add),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Builder(
      builder: (context) => BlocBuilder(
          cubit: BlocProvider.of<ChecklistBloc>(context),
           buildWhen: (previous, current){
             if(current is TaskUpdated2) {return false;}
             else {return true;}
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
                return SingleChildScrollView(
                  child: BlocBuilder(
                      cubit: BlocProvider.of<ShowTaskBloc>(context),
                      builder: (context, state) {
                        if (state is MonthLoading ||
                            state is MonthMovedPreviously ||
                            state is MonthMovedToNext) {
                          int month = months[state.number].month;
                          int year = months[state.number].year;
                          print("number ${state.number}");
                          //add tasks to list by month
                          valuess.clear();
                          for (int i = 0; i < tasks.length; i++) {
                            if(tasks[i].dueDate.month == month && tasks[i].dueDate.year == year){
                              valuess.add(tasks[i]);
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.black38,
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
                                        'THÁNG ${month}, ${year}',
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
                                        print("llll ${months.length}");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(15.0),
                                child: Text(
                                  "Đã quá hạn !",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListViewWidget(tasks: valuess,),
                              )
                            ],
                          );
                        }else return Text("có lỗi xảy ra");
                      }),
                );
            } else if (state is TasksLoading) {
              return LoadingIndicator();
            }
            return Container();
          }),
    );
  }
}
