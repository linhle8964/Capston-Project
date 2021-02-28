import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/bloc/show_task/bloc.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/firebase_repository/category_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/add_task/add_task.dart';
import 'package:wedding_app/screens/checklist/listview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/screens/checklist/searching_page.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Task> searchList = []; // searching

  TextEditingController _searchQuery= new TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }


  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    super.dispose();
  }


  _onSearchChanged(){
    print(_searchQuery);
    searchResultsList();
  }

  searchResultsList(){
    List<Task> showResults = [];
    if(_searchQuery.text.trim() != ""){
      for(var task in tasks){
        var name = task.name.toLowerCase();
        if(name.contains(_searchQuery.text.toLowerCase())){
          showResults.add(task);
        }
      }
    }else{
      showResults.clear();
    }
    setState(() {
       searchList = showResults;
     });
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

  List<Widget> _buildActions(context) {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: (){
          BlocProvider.of<ChecklistBloc>(context)
            ..add(SearchTasks());
          _startSearch();
          },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: getWeddingID(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final String weddingID = snapshot.data;
          return MultiBlocProvider(
            providers: [
              BlocProvider<CateBloc>(
                create: (BuildContext context) => CateBloc(
                  todosRepository: FirebaseCategoryRepository(),
                )..add(LoadTodos()),
              ),
              BlocProvider<ChecklistBloc>(
                  create: (BuildContext context)  {
                    return ChecklistBloc(
                      taskRepository: FirebaseTaskRepository(),
                    )..add(LoadSuccess(weddingID));}
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
                    BlocProvider.of<ShowTaskBloc>(context)..add(DeleteMonth());
                    BlocProvider.of<ChecklistBloc>(context)..add(LoadSuccess(weddingID));
                    _stopSearching();
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(content: new Text("bạn đã xóa thành công")));
                  } else if (state is TaskAdded) {
                    BlocProvider.of<ChecklistBloc>(context)..add(LoadSuccess(weddingID));
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(content: new Text("bạn đã thêm thành công")));
                  } else if (state is TaskUpdated) {
                    BlocProvider.of<ChecklistBloc>(context)..add(LoadSuccess(weddingID));
                    _stopSearching();
                    Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("bạn đã chỉnh sửa thành công")));
                  }
                },
                child: Scaffold(
                  key: scaffoldKey,
                  appBar: new AppBar(
                    centerTitle: true,
                    backgroundColor: hexToColor("#d86a77"),
                    leading:
                    _isSearching ?  BackButton(
                      color: Colors.white,
                      onPressed: (){
                        setState(() {
                          BlocProvider.of<ChecklistBloc>(context)
                            ..add(LoadSuccess(weddingID));
                          _stopSearching();
                        });
                      },
                    ) : null,
                    title: _isSearching ? _buildSearchField(context) : _buildTitle(context),
                    actions: _buildActions(context),
                  ),
                  body: _body(weddingID),
                  floatingActionButton:  _isSearching ? null : FloatingActionButton(
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
                    backgroundColor: Colors.lightBlue,
                  ),
                  floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
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
    );;
  }

  Widget _body(String weddingID) {
    return Builder(
      builder: (context) => BlocBuilder(
          cubit: BlocProvider.of<ChecklistBloc>(context),
           buildWhen: (previous, current){
             if(current is TaskUpdated2 ) {return false;}
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
                            state is MonthMovedToNext ||
                            state is MonthDeleted) {
                          int month = months[state.number].month;
                          int year = months[state.number].year;
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
                                    SizedBox(width: 10,),
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
                                child: ListViewWidget(tasks: valuess,weddingID: weddingID),
                              )
                            ],
                          );
                        }else return Text("có lỗi xảy ra");
                      }),
                );
            } else if (state is TasksLoading) {
              return Column(
                children: [
                  SizedBox(height: 10,),
                  Center(child: LoadingIndicator()),
                ],
              );
            } else if (state is TasksSearching ) {
              return SearchingResultPage(tasks: searchList);
            }
            return Container();
          }),
    );
  }
}
