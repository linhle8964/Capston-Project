import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/screens/guest/ListGuest.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/guest.dart';

class ViewGuestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewGuestPageState();
  }
}

class _ViewGuestPageState extends State<ViewGuestPage>
    with WidgetsBindingObserver {
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Guest> _data = [];
  List<Guest> _guests = [];
  List<Guest> _tempguests = [];
  int statusPage = -1;
  int c1 = 0, c2 = 0, c0 = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getWeddingID(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            final String weddingId = snapshot.data;
            return MultiBlocProvider(
              providers: [
                BlocProvider<GuestsBloc>(
                  create: (context) {
                    print("2");
                    return GuestsBloc(
                      guestsRepository: FirebaseGuestRepository(),
                    )..add(LoadGuests(weddingId));
                  },
                )
              ],
              child: Builder(
                  builder: (context) => BlocListener(
                    cubit: BlocProvider.of<GuestsBloc>(context),
                    listener: (context, state){
                    },
                    child: Scaffold(
                      key: scaffoldKey,
                      appBar: new AppBar(
                        centerTitle: true,
                        backgroundColor: hexToColor("#d86a77"),
                        title: const Text("Khách mời"),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              SearchGuest(context, weddingId);
                            },
                          ),
                        ]
                      ),
                      body: _body(weddingId),
                      floatingActionButton: FloatingActionButton(
                        tooltip: 'Mời thêm khách',
                        child: Icon(Icons.add),
                        backgroundColor: hexToColor("#d86a77"),
                        onPressed: () {
                          print('invite guest');
                          AddGuestDialog(context, weddingId);
                        },
                      ),
                          floatingActionButtonLocation:
                            FloatingActionButtonLocation.endFloat,
                    ),
                  )
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }

  Widget _body(String weddingId) {
    return Builder(
        builder: (context) =>BlocBuilder(
            cubit: BlocProvider.of<GuestsBloc>(context),
            buildWhen: (previous, current){
              if(current is GuestUpdated){return false;}
              else {return true;}
            },
            builder: (context, state) {
                if(state is GuestsLoaded){
                  _guests.clear();
                  _guests = state.guests;
                  _tempguests = _guests;
                  c0 = _guests.where((_guest) => _guest.status == 0).toList().length;
                  c1 = _guests.where((_guest) => _guest.status == 1).toList().length;
                  c2 = _guests.where((_guest) => _guest.status == 2).toList().length;
                  return SafeArea(
                    minimum: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: SingleChildScrollView(
                        child: BlocBuilder(
                            cubit: BlocProvider.of<GuestsBloc>(context),
                            builder: (context, state){
                              _data.clear();
                              if(statusPage == -1){
                                for(int i = 0; i < _tempguests.length; i++){
                                  _data.add(_tempguests[i]);
                                }
                              }else {
                                for(int i = 0; i < _tempguests.length; i++){
                                  if(_tempguests[i].status == statusPage)
                                    _data.add(_tempguests[i]);
                                }
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: FlatButton(
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '$c1',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    'Sẽ tới',
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                ]),
                                            color: hexToColor("#85e3ff"),
                                            height: 60,
                                            onPressed: () {
                                              print('coming');
                                              statusPage = 1;
                                              BlocProvider.of<GuestsBloc>(context).add(LoadGuests(weddingId));
                                            },
                                          )),
                                      Expanded(
                                          child: FlatButton(
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                            color: hexToColor("#ff9cee"),
                                            height: 60,
                                            onPressed: () {
                                              print('not coming');
                                              statusPage = 2;
                                              BlocProvider.of<GuestsBloc>(context).add(LoadGuests(weddingId));
                                            },
                                          )),
                                      Expanded(
                                          child: FlatButton(
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                            color: hexToColor("#6eb5ff"),
                                            height: 60,
                                            onPressed: () {
                                              print('waiting');
                                              statusPage = 0;
                                              BlocProvider.of<GuestsBloc>(context).add(LoadGuests(weddingId));
                                            },
                                          )),
                                      Expanded(
                                          child: FlatButton(
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                            color: hexToColor("#ffc9de"),
                                            height: 60,
                                            onPressed: () {
                                              print('total');
                                              statusPage = -1;
                                              BlocProvider.of<GuestsBloc>(context).add(LoadGuests(weddingId));
                                            },
                                          )),
                                    ],
                                  ),
                                  ListGuest(_data, weddingId)
                                ],
                              );
                            }
                        )
                    ),
                  );
                }else{
                  return Center(child: LoadingIndicator());
                }
              }
        )
    );
  }

  Future<void> AddGuestDialog(BuildContext context, String weddingId) async{
    return await showDialog(context: context,
        builder: (context){
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
                    minWidth: MediaQuery.of(context).size.width/2 - 55,
                    height: MediaQuery.of(context).size.width/2 - 55,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.pinkAccent,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 60,),
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
                    onPressed: (){
                      Navigator.of(context).pop();
                      AddGuestByHandDialog(context, weddingId);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  FlatButton(
                    minWidth: MediaQuery.of(context).size.width/2 - 55,
                    height: MediaQuery.of(context).size.width/2 - 55,
                    color: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_ic_call, color: Colors.white, size: 60,),
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
                    onPressed: (){
                      Navigator.of(context).pop();
                      AddGuestFromContact(context, _tempguests, weddingId);
                    },
                  ),
                ],
              )
            ],
          );
        }
    );
  }

  Future<void> AddGuestByHandDialog(BuildContext context, String weddingId) async{
    return await showDialog(context: context,
        builder: (context) {
          String _name = "";
          String _description = "";
          String _phone = "";
          int _status = 0;
          int group = _status;
          return StatefulBuilder(builder: (context, setState){
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
                            initialValue: _name,
                            decoration: InputDecoration(
                              labelText: "Tên",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (input) => input.isNotEmpty ? null:"Chưa nhập tên khách mời!",
                            onSaved: (input) => _name = input,
                          ),
                          TextFormField(
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
                                          groupValue: group,
                                          onChanged: (T){
                                            _status = T;
                                            setState(() {
                                              group = T;
                                            });
                                          }
                                      ),
                                      Text("Đã mời"),
                                    ],
                                  )
                              ),
                              Expanded(
                                  child: Column(
                                    children: [
                                      Radio(
                                          value: 1,
                                          groupValue: group,
                                          onChanged: (T){
                                            _status = T;
                                            setState(() {
                                              group = T;
                                            });
                                          }
                                      ),
                                      Text("Sẽ tới"),
                                    ],
                                  )
                              ),
                              Expanded(
                                  child: Column(
                                    children: [
                                      Radio(
                                          value: 2,
                                          groupValue: group,
                                          onChanged: (T){
                                            _status = T;
                                            setState(() {
                                              group = T;
                                            });
                                          }
                                      ),
                                      Text("Không tới"),
                                    ],
                                  )
                              ),
                            ],
                          ),
                          TextFormField(
                            initialValue: _phone,
                            decoration: InputDecoration(
                              labelText: "Điện thoại",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (input) {
                              RegExp regex = new RegExp(
                                r'(^(?:[+0]9)?[0-9]{9,10}$)',
                                caseSensitive: false,
                                multiLine: false,
                              );
                              if(input.isNotEmpty && isChecked(_tempguests, input)){
                                return "Số điện thoại đã tồn tại";
                              }else if(!regex.hasMatch(input)){
                                return "Số điện thoại không hợp lệ";
                              }else{
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
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              Guest _guest = new Guest(_name, _description, _status, _phone);
                              addGuest(context, _guest, weddingId);
                              Navigator.of(context).pop();
                              AddGuestDialog(context, weddingId);
                            }
                          },
                        ),
                      ),
                      TextButton(
                        child: Text('Hủy'),
                        onPressed: (){
                          Navigator.of(context).pop();
                          AddGuestDialog(context, weddingId);
                        },
                      ),
                    ],
                  ),
                )
            );
          });
        }
    );
  }

  getContacts() async
  {
    final PermissionStatus permissionStatus = await _getPermission();
    List<Contact> listContacts = [];
    print(permissionStatus.toString());
    if (permissionStatus == PermissionStatus.granted) {
      Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      listContacts = contacts.toList();
    }
    return listContacts;
  }
  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  bool isChecked(List<Guest> guests, String phone){
    for(int i = 0; i < guests.length; i++){
      if(guests[i].phone == phone) return true;
    }
    return false;
  }

  Future<void> AddGuestFromContact(BuildContext context, List<Guest> guests, String weddingId) async{
    return await showDialog(context: context,
        builder: (context) {
          return new FutureBuilder(
            future: getContacts(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                List<Contact> listContacts = snapshot.data;
                List<Guest> listAddGuests = [];
                List<Contact> listAvaiContacts = [];
                for(int i = 0; i< listContacts.length; i++){
                  if(!isChecked(guests, listContacts[i].phones.elementAt(0).value)){
                    listAvaiContacts.add(listContacts[i]);
                  }
                }
                return StatefulBuilder(builder: (context, setState){
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: listAvaiContacts.length,
                                      itemBuilder: (context,index){
                                        Contact contact = listAvaiContacts[index];
                                        String phone = contact.phones.elementAt(0).value;
                                        return Card(
                                          child: ListTile(
                                            title: Text("${contact.displayName}"),
                                            subtitle: Text((contact.phones.length>0)?"${phone}":"No contact"),
                                            trailing: Checkbox(value: isChecked(listAddGuests, phone), onChanged: (checked){
                                              setState((){
                                                Guest guest = new Guest(contact.displayName,"",0,phone);
                                                if(!isChecked(listAddGuests, phone)){
                                                  listAddGuests.add(guest);
                                                }
                                                else {
                                                  listAddGuests.removeAt(listAddGuests.indexWhere((guest) => guest.phone == phone));
                                                }
                                              });
                                            },),
                                          ),
                                        );
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Builder(
                            builder: (context) => TextButton(
                              child: Text('Thêm khách'),
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  _formKey.currentState.save();
                                  addListGuest(context, listAddGuests, weddingId);
                                  Navigator.of(context).pop();
                                  AddGuestDialog(context, weddingId);
                                }
                              },
                            ),
                          ),
                          TextButton(
                            child: Text('Hủy'),
                            onPressed: (){
                              Navigator.of(context).pop();
                              AddGuestDialog(context, weddingId);
                            },
                          ),
                        ],
                      )
                  );
                });
              }else{
                return Center(child: AlertDialog(content: LoadingIndicator()));
              }
            },
          );
        }
    );
  }

  Future<void> SearchGuest(BuildContext context, String weddingId) async{
    return await showDialog(context: context,
        builder: (context) {
          String _searchQuery = "";
          List<Guest> _listSearch = [];
          for (var guest in _tempguests) {
            var name = guest.name.toLowerCase();
            var phone = guest.phone.toLowerCase();
            if (name.contains(_searchQuery.toLowerCase()) || phone.contains(_searchQuery.toLowerCase())) {
              _listSearch.add(guest);
            }
          }
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
                  listener: (context, state){
                  },
                  child: Builder(
                      builder: (context) =>BlocBuilder(
                          cubit: BlocProvider.of<GuestsBloc>(context),
                          buildWhen: (previous, current){
                            if(current is GuestUpdated){return false;}
                            else {return true;}
                          },
                          builder: (context, state) {
                            if(state is GuestsLoaded){
                              return StatefulBuilder(builder: (context, setState){
                                _listSearch.clear();
                                _guests = state.guests;
                                _tempguests = _guests;
                                for (var guest in _tempguests) {
                                  var name = guest.name.toLowerCase();
                                  var phone = guest.phone.toLowerCase();
                                  if (name.contains(_searchQuery.toLowerCase()) || phone.contains(_searchQuery.toLowerCase())) {
                                    _listSearch.add(guest);
                                  }
                                }
                                return SingleChildScrollView(
                                    child:MultiBlocProvider(
                                        providers: [
                                          BlocProvider<GuestsBloc>(
                                            create: (context) {
                                              return GuestsBloc(
                                                guestsRepository: FirebaseGuestRepository(),
                                              )..add(LoadGuests(weddingId));
                                            },
                                          ),
                                        ],
                                        child: AlertDialog(contentPadding: EdgeInsets.all(1),
                                          content: Form(
                                            key: _formKey,
                                            child: Container(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      TextFormField(
                                                        //controller: ,
                                                          initialValue: _searchQuery,
                                                          decoration: InputDecoration(
                                                            labelText: "Tìm kiếm khách mời",
                                                            fillColor: Colors.white,
                                                            filled: true,
                                                          ),
                                                          onChanged: (input) {
                                                            setState((){
                                                              _searchQuery = input;
                                                              print(_searchQuery);
                                                            });
                                                          }
                                                      ),
                                                      Builder(
                                                          builder: (context) {
                                                            if (_listSearch.length != 0) {
                                                              return ListGuest(
                                                                  _listSearch,  weddingId
                                                              );
                                                            } else {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      'Không có khách mời phù hợp !',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                          }
                                                      )
                                                    ]
                                                )
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Hủy'),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        )
                                    )
                                );
                              });
                            }else{
                              return Center(child: LoadingIndicator());
                            }
                          }
                      )
                  ),
                )
            ),
          );
        }
    );
  }

  void addListGuest(var context, List<Guest> guests, String weddingId){
    if(guests.length > 0){
      for(int i = 0; i < guests.length; i++){
        BlocProvider.of<GuestsBloc>(context)..add(AddGuest(guests[i], weddingId));
      }
    }
  }

  void addGuest(var context, Guest guest, String weddingId){
    BlocProvider.of<GuestsBloc>(context)..add(AddGuest(guest, weddingId));
  }
}
