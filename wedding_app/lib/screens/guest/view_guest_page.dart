import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/screens/guest/ListGuest.dart';
import 'package:wedding_app/screens/guest/download_guest_excel.dart';
import 'package:wedding_app/utils/check_existed_phone.dart';
import 'package:wedding_app/utils/count_guest_item.dart';
import 'package:wedding_app/utils/format_number.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ListGuestMoney.dart';

class ViewGuestPage extends StatefulWidget {
  final UserWedding userWedding;
  ViewGuestPage({Key key, @required this.userWedding}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ViewGuestPageState();
  }
}

class _ViewGuestPageState extends State<ViewGuestPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Guest> _data = [];
  List<Guest> _guests = [];
  List<Guest> _tempguests = [];
  int statusPage = -1;
  int c1 = 0, c2 = 0, c0 = 0;
  int _selectedTypeItem = 3;
  List<String> _typeItems = ["Chưa sắp xếp", "Nhà trai", "Nhà gái", "Tất cả"];

  TabController _tabController;
  int _selectedTab = 0;

  var ctx;
  Offset fabPosition = Offset(20.0, 20.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTab = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  getAppBar(String weddingId) {
    return AppBar(
      backgroundColor: hexToColor("#d86a77"),
      title: const Text("Khách mời"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.download_outlined,
            color: Colors.white,
          ),
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
            SearchGuest(context, weddingId);
          },
        ),
        _typePopup(_selectedTab, weddingId),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50), // Creates border
          color: Colors.greenAccent,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment,
                  color: Colors.white,
                ),
                Text(
                  'Thông tin',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Tab(
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    'Tiền mừng',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    final UserWedding userWedding = widget.userWedding;
    final String weddingId = userWedding.weddingId;
    return BlocProvider<GuestsBloc>(
      create: (context) {
        return GuestsBloc(
          guestsRepository: FirebaseGuestRepository(),
        )..add(LoadGuests(weddingId));
      },
      child: Builder(builder: (context) {
        appBar = getAppBar(weddingId);
        if (isAdmin(userWedding.role)) {
          return BlocListener(
            cubit: BlocProvider.of<GuestsBloc>(context),
            listener: (context, state) {},
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                key: scaffoldKey,
                appBar: appBar,
                body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      BlocProvider<GuestsBloc>(
                          create: (context) {
                            return GuestsBloc(
                              guestsRepository: FirebaseGuestRepository(),
                            )..add(LoadGuests(weddingId));
                          },
                          child: _infoTab(weddingId)),
                      BlocProvider<GuestsBloc>(
                        create: (context) {
                          return GuestsBloc(
                            guestsRepository: FirebaseGuestRepository(),
                          )..add(LoadGuests(weddingId));
                        },
                        child: _moneyTab(weddingId),
                      ),
                    ]),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: hexToColor("#d86a77"),
                  onPressed: () {
                    print('invite guest');
                    if (_tabController.index == 0)
                      AddGuestDialog(context, weddingId);
                    else if (_tabController.index == 1)
                      addMoneyDialog(context, weddingId);
                  },
                ),
                floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
                ),
              ),
            );
        } else {
          return BlocListener(
            cubit: BlocProvider.of<GuestsBloc>(context),
            listener: (context, state) {},
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                key: scaffoldKey,
                appBar: new AppBar(
                  backgroundColor: hexToColor("#d86a77"),
                  title: const Text("Khách mời"),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.download_outlined,
                        color: Colors.white,
                      ),
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
                        SearchGuest(context, weddingId);
                      },
                    ),
                    _typePopup(_selectedTab, weddingId),
                  ],
                ),
                body: _infoTab(weddingId),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: hexToColor("#d86a77"),
                  onPressed: () {
                    print('invite guest');
                    if (_tabController.index == 0)
                      AddGuestDialog(context, weddingId);
                    else if (_tabController.index == 1)
                      addMoneyDialog(context, weddingId);
                  },
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _typePopup(int tabIndex, String weddingId) {
    if (tabIndex == 0) {
      return PopupMenuButton<String>(
        itemBuilder: (context) {
          return _typeItems.map((String choice) {
            return PopupMenuItem<String>(
              value: _typeItems.indexOf(choice).toString(),
              child: Text(choice),
            );
          }).toList();
        },
        onSelected: (choice) {
          _selectedTypeItem = int.parse(choice);
          statusPage = -1;
          print(_selectedTypeItem);
          BlocProvider.of<GuestsBloc>(ctx)..add(LoadGuests(weddingId));
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _infoTab(String weddingId) {
    return Builder(
        builder: (context) => BlocBuilder(
            cubit: BlocProvider.of<GuestsBloc>(context),
            buildWhen: (previous, current) {
              if (current is GuestUpdated) {
                return false;
              } else {
                return true;
              }
            },
            builder: (context, state) {
              ctx = context;
              if (state is GuestsLoaded) {
                _guests.clear();
                _guests = state.guests;
                _tempguests = _guests;
                c0 = _guests
                    .where((_guest) => _guest.status == 0)
                    .toList()
                    .length;
                c1 = _guests
                    .where((_guest) => _guest.status == 1)
                    .toList()
                    .length;
                c2 = _guests
                    .where((_guest) => _guest.status == 2)
                    .toList()
                    .length;
                return SafeArea(
                  minimum: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: SingleChildScrollView(
                      child: BlocBuilder(
                          cubit: BlocProvider.of<GuestsBloc>(context),
                          builder: (context, state) {
                            _data.clear();
                            for (int i = 0; i < _tempguests.length; i++) {
                              if (statusPage == -1) {
                                if (_selectedTypeItem == 3) {
                                  _data.add(_tempguests[i]);
                                } else {
                                  if (_tempguests[i].type ==
                                          _selectedTypeItem &&
                                      (_tempguests[i].status == 1 ||
                                          _tempguests[i].status == 0))
                                    _data.add(_tempguests[i]);
                                }
                              } else {
                                if (_tempguests[i].status == statusPage) {
                                  if (_selectedTypeItem == 3) {
                                    _data.add(_tempguests[i]);
                                  } else {
                                    if (_tempguests[i].type ==
                                            _selectedTypeItem &&
                                        (_tempguests[i].status == 1 ||
                                            _tempguests[i].status == 0))
                                      _data.add(_tempguests[i]);
                                  }
                                }
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: FlatButton(
                                          child: Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        countCompanion(_tempguests),
                                                        style:
                                                            TextStyle(fontSize: 12),
                                                      ),
                                                      Icon(
                                                        Icons.accessibility,
                                                        size: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '$c1',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              'Sẽ tới',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ]),
                                          color: (statusPage == 1)?hexToColor("#85e3ff"):Colors.transparent,
                                          textColor: (statusPage == 1)?Colors.white:hexToColor("#85e3ff"),
                                          height: 60,
                                          onPressed: () {
                                            print('coming');
                                            statusPage = 1;
                                            BlocProvider.of<GuestsBloc>(context)
                                            .add(LoadGuests(weddingId));
                                            },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(color: hexToColor("#85e3ff"))
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        child: FlatButton(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$c2',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              'Không tới',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ]),
                                      color: (statusPage == 2)?hexToColor("#ff9cee"):Colors.transparent,
                                          textColor: (statusPage == 2)?Colors.white:hexToColor("#ff9cee"),
                                      height: 60,
                                      onPressed: () {
                                        print('not coming');
                                        statusPage = 2;
                                        BlocProvider.of<GuestsBloc>(context)
                                            .add(LoadGuests(weddingId));
                                      },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(color: hexToColor("#ff9cee"))
                                          ),
                                    )
                                    ),
                                    Expanded(
                                        child: FlatButton(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$c0',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              'Đã mời',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ]),
                                      color: (statusPage == 0)?hexToColor("#6eb5ff"):Colors.transparent,
                                          textColor: (statusPage == 0)?Colors.white:hexToColor("#6eb5ff"),
                                          height: 60,
                                      onPressed: () {
                                        print('waiting');
                                        statusPage = 0;
                                        BlocProvider.of<GuestsBloc>(context)
                                            .add(LoadGuests(weddingId));
                                      },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(color: hexToColor("#6eb5ff"))
                                          ),
                                    )
                                    ),
                                    Expanded(
                                        child: FlatButton(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${c0 + c1 + c2}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              'Tổng',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ]),
                                          color: (statusPage == -1)?hexToColor("#d86a77"):Colors.transparent,
                                          textColor: (statusPage == -1)?Colors.white:hexToColor("#d86a77"),
                                      height: 60,
                                      onPressed: () {
                                        print('total');
                                        statusPage = -1;
                                        BlocProvider.of<GuestsBloc>(context)
                                            .add(LoadGuests(weddingId));
                                      },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(color: hexToColor("#d86a77"))
                                          ),
                                    )
                                    ),
                                  ],
                                ),
                                ListGuest(_data, widget.userWedding)
                              ],
                            );
                          })),
                );
              } else {
                return Center(child: LoadingIndicator());
              }
            }));
  }

  Widget _moneyTab(String weddingId) {
    return Builder(
        builder: (context) => BlocBuilder(
            cubit: BlocProvider.of<GuestsBloc>(context),
            buildWhen: (previous, current) {
              if (current is GuestUpdated) {
                return false;
              } else {
                return true;
              }
            },
            builder: (context, state) {
              if (state is GuestsLoaded) {
                _guests.clear();
                _guests = state.guests;
                _tempguests = _guests;
                return SafeArea(
                  minimum: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: SingleChildScrollView(
                      child: BlocBuilder(
                          cubit: BlocProvider.of<GuestsBloc>(context),
                          builder: (context, state) {
                            _data.clear();
                            for (int i = 0; i < _tempguests.length; i++) {
                              if (_tempguests[i].money > 0) {
                                _data.add(_tempguests[i]);
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/image/money_back.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formatCurrency(countMoney(_tempguests)),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                                ListGuestMoney(_data, weddingId)
                              ],
                            );
                          })),
                );
              } else {
                return Center(child: LoadingIndicator());
              }
            }));
  }

  Future<void> addMoneyDialog(BuildContext context, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String _searchQuery = "";
          List<Guest> _listSearch = [];
          return MultiBlocProvider(
            providers: [
              BlocProvider<GuestsBloc>(
                create: (context) {
                  return GuestsBloc(
                    guestsRepository: FirebaseGuestRepository(),
                  )..add(LoadGuests(weddingId));
                },
              )
            ],
            child: Builder(
                builder: (context) => BlocListener(
                      cubit: BlocProvider.of<GuestsBloc>(context),
                      listener: (context, state) {},
                      child: Builder(
                          builder: (context) => BlocBuilder(
                              cubit: BlocProvider.of<GuestsBloc>(context),
                              buildWhen: (previous, current) {
                                if (current is GuestUpdated) {
                                  return false;
                                } else {
                                  return true;
                                }
                              },
                              builder: (context, state) {
                                if (state is GuestsLoaded) {
                                  _listSearch.clear();
                                  _guests = state.guests;
                                  _tempguests = _guests;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    _listSearch.clear();
                                    for (var guest in _tempguests) {
                                      var name = guest.name.toLowerCase();
                                      var phone = guest.phone.toLowerCase();
                                      var money = guest.money;
                                      if ((name.contains(
                                                  _searchQuery.toLowerCase()) ||
                                              phone.contains(_searchQuery
                                                  .toLowerCase())) &&
                                          money == 0) {
                                        _listSearch.add(guest);
                                        print(guest);
                                      }
                                    }
                                    return SingleChildScrollView(
                                        child: MultiBlocProvider(
                                            providers: [
                                          BlocProvider<GuestsBloc>(
                                            create: (context) {
                                              return GuestsBloc(
                                                guestsRepository:
                                                    FirebaseGuestRepository(),
                                              )..add(LoadGuests(weddingId));
                                            },
                                          ),
                                        ],
                                            child: AlertDialog(
                                              contentPadding: EdgeInsets.all(1),
                                              content: Form(
                                                key: _formKey,
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            180,
                                                    width: 2000,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          TextFormField(
                                                              //controller: ,
                                                              initialValue:
                                                                  _searchQuery,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Tìm kiếm khách mời",
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                filled: true,
                                                              ),
                                                              onChanged:
                                                                  (input) {
                                                                setState(() {
                                                                  _searchQuery =
                                                                      input;
                                                                  print(
                                                                      _searchQuery);
                                                                });
                                                              }),
                                                          Builder(builder:
                                                              (context) {
                                                            if (_listSearch
                                                                    .length !=
                                                                0) {
                                                              return ListGuest(
                                                                  _listSearch,
                                                                  widget
                                                                      .userWedding);
                                                            } else {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Không có khách mời phù hợp !',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                          })
                                                        ])),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Hủy'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            )));
                                  });
                                } else {
                                  return Center(child: LoadingIndicator());
                                }
                              })),
                    )),
          );
        });
  }

  Future<void> AddGuestDialog(BuildContext context, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            content: Text(
              "Thêm khách mời cho đám cưới của bạn <3",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                    minWidth: MediaQuery.of(context).size.width / 2 - 55,
                    height: MediaQuery.of(context).size.width / 2 - 55,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.pinkAccent,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 60,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Nhập tay",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      AddGuestByHandDialog(context, weddingId);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  FlatButton(
                    minWidth: MediaQuery.of(context).size.width / 2 - 55,
                    height: MediaQuery.of(context).size.width / 2 - 55,
                    color: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_ic_call,
                            color: Colors.white,
                            size: 60,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Từ danh bạ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      AddGuestFromContact(context, _tempguests, weddingId);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> AddGuestByHandDialog(
      BuildContext context, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String _name = "";
          String _description = "";
          String _phone = "";
          int _status = 0;
          int groupStt = _status;
          int _type = 0;
          int groupType = _type;
          int _companion = 0;
          String _congrat = "";
          int _money = 0;
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: MultiBlocProvider(
              providers: [
                BlocProvider<GuestsBloc>(
                  create: (context) {
                    return GuestsBloc(
                      guestsRepository: FirebaseGuestRepository(),
                    )..add(LoadGuests(weddingId));
                  },
                ),
              ],
              child: AlertDialog(
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: "Tên",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (input) => input.isNotEmpty
                            ? null
                            : "Chưa nhập tên khách mời!",
                        onSaved: (input) => _name = input,
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: "Chú thích",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onSaved: (input) => _description = input,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Radio(
                                  value: 0,
                                  groupValue: groupStt,
                                  onChanged: (T) {
                                    _status = T;
                                    setState(() {
                                      groupStt = T;
                                    });
                                  }),
                              Text("Đã mời"),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Radio(
                                  value: 1,
                                  groupValue: groupStt,
                                  onChanged: (T) {
                                    _status = T;
                                    setState(() {
                                      groupStt = T;
                                    });
                                  }),
                              Text("Sẽ tới"),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Radio(
                                  value: 2,
                                  groupValue: groupStt,
                                  onChanged: (T) {
                                    _status = T;
                                    setState(() {
                                      groupStt = T;
                                    });
                                  }),
                              Text("Không tới"),
                            ],
                          )),
                        ],
                      ),
                      Builder(builder: (context) {
                        if (groupStt == 1) {
                          return Column(
                            children: [
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                initialValue: _companion.toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Số người đi cùng",
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                onSaved: (input) =>
                                    _companion = int.parse(input),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                      Builder(
                        builder: (context) {
                          if (groupStt == 1 || groupStt == 0) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Radio(
                                            value: 0,
                                            groupValue: groupType,
                                            onChanged: (T) {
                                              _type = T;
                                              setState(() {
                                                groupType = T;
                                              });
                                            }),
                                        Text("Chưa xếp"),
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Radio(
                                            value: 1,
                                            groupValue: groupType,
                                            onChanged: (T) {
                                              _type = T;
                                              setState(() {
                                                groupType = T;
                                              });
                                            }),
                                        Text("Nhà trai"),
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Radio(
                                            value: 2,
                                            groupValue: groupType,
                                            onChanged: (T) {
                                              _type = T;
                                              setState(() {
                                                groupType = T;
                                              });
                                            }),
                                        Text("Nhà gái"),
                                      ],
                                    )),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        initialValue: _phone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Điện thoại",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (input) {
                          RegExp regex = new RegExp(
                            r'(^(?:[+0]9)?[0-9]{10}$)',
                            caseSensitive: false,
                            multiLine: false,
                          );
                          if (input.isNotEmpty &&
                              checkExistedPhoneToAdd(_tempguests, input)) {
                            return "Số điện thoại đã tồn tại";
                          } else if (!regex.hasMatch(input)) {
                            return "Số điện thoại không hợp lệ";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) => _phone = input,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Builder(
                    builder: (context) => TextButton(
                      child: Text('Thêm khách'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Guest _guest = new Guest(_name, _description, _status,
                              _phone, _type, _companion, _congrat, _money);
                          addGuest(context, _guest, weddingId);
                          Navigator.of(context).pop();
                          AddGuestDialog(context, weddingId);
                        }
                      },
                    ),
                  ),
                  TextButton(
                    child: Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      AddGuestDialog(context, weddingId);
                    },
                  ),
                ],
              ),
            ));
          });
        });
  }

  Future<List<Contact>> getContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    List<Contact> listContacts = [];
    print(permissionStatus.toString());
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
    if (permissionStatus == PermissionStatus.granted) {
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      listContacts = contacts.toList();
    }
    return listContacts;
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  Future<void> AddGuestFromContact(
      BuildContext context, List<Guest> guests, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return new FutureBuilder(
            future: getContacts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Contact> listContacts = snapshot.data;
                List<Guest> listAddGuests = [];
                List<Contact> listAvaiContacts = [];
                if (guests.isEmpty) {
                  for (int i = 0; i < listContacts.length; i++) {
                    if (listContacts[i].phones.isNotEmpty) {
                      listAvaiContacts.add(listContacts[i]);
                    }
                  }
                } else {
                  for (int i = 0; i < listContacts.length; i++) {
                    if (listContacts[i].phones.isNotEmpty) {
                      if (!checkExistedPhoneToAdd(
                          guests, listContacts[i].phones.elementAt(0).value.replaceAll(new RegExp(r"\s+"), ""))) {
                        listAvaiContacts.add(listContacts[i]);
                      }
                    }
                  }
                }
                return StatefulBuilder(builder: (context, setState) {
                  return MultiBlocProvider(
                      providers: [
                        BlocProvider<GuestsBloc>(
                          create: (context) {
                            return GuestsBloc(
                              guestsRepository: FirebaseGuestRepository(),
                            )..add(LoadGuests(weddingId));
                          },
                        ),
                      ],
                      child: AlertDialog(
                        content: Form(
                          key: _formKey,
                          child: Container(
                            height: MediaQuery.of(context).size.height - 100,
                            width: 2000,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: listAvaiContacts.length,
                                itemBuilder: (context, index) {
                                  Contact contact = listAvaiContacts[index];
                                  String phone =
                                      contact.phones.elementAt(0).value.replaceAll(new RegExp(r"\s+"), "");
                                  return Card(
                                    child: ListTile(
                                      title: Text("${contact.displayName}"),
                                      subtitle: Text((contact.phones.length > 0)
                                          ? "${phone}"
                                          : "No contact"),
                                      trailing: Checkbox(
                                        value: checkExistedPhoneToAdd(listAddGuests, phone),
                                        onChanged: (checked) {
                                          setState(() {
                                            Guest guest = new Guest(
                                                contact.displayName,
                                                "",
                                                0,
                                                phone,
                                                0,
                                                0,
                                                "",
                                                0);
                                            if (!checkExistedPhoneToAdd(
                                                listAddGuests, phone)) {
                                              listAddGuests.add(guest);
                                            } else {
                                              listAddGuests.removeAt(
                                                  listAddGuests.indexWhere(
                                                      (guest) =>
                                                          guest.phone ==
                                                          phone));
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        actions: <Widget>[
                          Builder(
                            builder: (context) => TextButton(
                              child: Text('Thêm khách'),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  addListGuest(
                                      context, listAddGuests, weddingId);
                                  Navigator.of(context).pop();
                                  AddGuestDialog(context, weddingId);
                                }
                              },
                            ),
                          ),
                          TextButton(
                            child: Text('Hủy'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              AddGuestDialog(context, weddingId);
                            },
                          ),
                        ],
                      ));
                });
              } else {
                return Center(child: AlertDialog(content: LoadingIndicator()));
              }
            },
          );
        });
  }

  Future<void> SearchGuest(BuildContext context, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String _searchQuery = "";
          List<Guest> _listSearch = [];
          return MultiBlocProvider(
            providers: [
              BlocProvider<GuestsBloc>(
                create: (context) {
                  return GuestsBloc(
                    guestsRepository: FirebaseGuestRepository(),
                  )..add(LoadGuests(weddingId));
                },
              )
            ],
            child: Builder(
                builder: (context) => BlocListener(
                      cubit: BlocProvider.of<GuestsBloc>(context),
                      listener: (context, state) {},
                      child: Builder(
                          builder: (context) => BlocBuilder(
                              cubit: BlocProvider.of<GuestsBloc>(context),
                              buildWhen: (previous, current) {
                                if (current is GuestUpdated) {
                                  return false;
                                } else {
                                  return true;
                                }
                              },
                              builder: (context, state) {
                                if (state is GuestsLoaded) {
                                  _listSearch.clear();
                                  _guests = state.guests;
                                  _tempguests = _guests;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    _listSearch.clear();
                                    for (var guest in _tempguests) {
                                      var name = guest.name.toLowerCase();
                                      var phone = guest.phone.toLowerCase();
                                      if (name.contains(
                                              _searchQuery.toLowerCase()) ||
                                          phone.contains(
                                              _searchQuery.toLowerCase())) {
                                        _listSearch.add(guest);
                                        print(guest);
                                      }
                                    }
                                    return SingleChildScrollView(
                                        child: MultiBlocProvider(
                                            providers: [
                                          BlocProvider<GuestsBloc>(
                                            create: (context) {
                                              return GuestsBloc(
                                                guestsRepository:
                                                    FirebaseGuestRepository(),
                                              )..add(LoadGuests(weddingId));
                                            },
                                          ),
                                        ],
                                            child: AlertDialog(
                                              contentPadding: EdgeInsets.all(1),
                                              content: Form(
                                                key: _formKey,
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            180,
                                                    width: 2000,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          TextFormField(
                                                              //controller: ,
                                                              initialValue:
                                                                  _searchQuery,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Tìm kiếm khách mời",
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                filled: true,
                                                              ),
                                                              onChanged:
                                                                  (input) {
                                                                setState(() {
                                                                  _searchQuery =
                                                                      input;
                                                                  print(
                                                                      _searchQuery);
                                                                });
                                                              }),
                                                          Builder(builder:
                                                              (context) {
                                                            if (_listSearch
                                                                    .length !=
                                                                0) {
                                                              return ListGuest(
                                                                  _listSearch,
                                                                  widget
                                                                      .userWedding);
                                                            } else {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Không có khách mời phù hợp !',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                          })
                                                        ])),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Hủy'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            )));
                                  });
                                } else {
                                  return Center(child: LoadingIndicator());
                                }
                              })),
                    )),
          );
        });
  }

  showMyAlertDialog(BuildContext context) {
    GlobalKey _containerKey = GlobalKey();
    // Create AlertDialog
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content: Text("Bạn có muốn lưu lại danh sách khách dưới dạng file excel?"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
            child: Text("Có",style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
              downloadFile(_data, context, widget.userWedding.role);
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

  void addListGuest(var context, List<Guest> guests, String weddingId) {
    if (guests.length > 0) {
      for (int i = 0; i < guests.length; i++) {
        BlocProvider.of<GuestsBloc>(context)
          ..add(AddGuest(guests[i], weddingId));
      }
    }
  }

  void addGuest(var context, Guest guest, String weddingId) {
    BlocProvider.of<GuestsBloc>(context)..add(AddGuest(guest, weddingId));
  }
}
