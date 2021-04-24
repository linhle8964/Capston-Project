import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/utils/check_existed_phone.dart';
import 'package:wedding_app/utils/get_information.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/utils/hex_color.dart';

import '../../model/guest.dart';

class ListGuest extends StatefulWidget {
  final List<Guest> guests;
  final UserWedding userWedding;

  ListGuest(this.guests, this.userWedding);

  @override
  _ListGuestState createState() => _ListGuestState();
}

class _ListGuestState extends State<ListGuest> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Widget _companionPart(Guest guest) {
    return Builder(builder: (context) {
      if (guest.status == 1) {
        return Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(right: 5)),
            Text(
              (guest.companion + 1).toString(),
            ),
            Icon(
              Icons.accessibility,
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isAdmin(widget.userWedding.role)
          ? MediaQuery.of(context).size.height - 250
          : MediaQuery.of(context).size.height - 200,
      child: ListView.builder(
        itemCount: widget.guests.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: Stack(children: [
              new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  elevation: 5,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text(
                              widget.guests[index].name,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                            Padding(padding: EdgeInsets.all(2)),
                            Text(
                              widget.guests[index].description,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                            Builder(builder: (context) {
                              if (widget.guests[index].status == 1 ||
                                  widget.guests[index].status == 0) {
                                return Row(
                                  children: [
                                    Icon(Icons.home_outlined),
                                    Text(
                                      getType(widget.guests[index].type),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                            Padding(padding: EdgeInsets.only(bottom: 5)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                getStatus(widget.guests[index].status),
                                style: TextStyle(
                                  color: hexToColor(
                                      getColor(widget.guests[index].status)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: hexToColor(getColor(
                                          widget.guests[index].status)),
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            _companionPart(widget.guests[index]),
                            Padding(padding: EdgeInsets.only(right: 10)),
                          ],
                        ),
                      ),
                    ],
                  )),
              Builder(builder: (context) {
                if (isAdmin(widget.userWedding.role)) {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              showGuestMoneyDialog(
                                  context, index, widget.userWedding.weddingId);
                            })),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ]),
            onTap: () {
              print(widget.guests[index].name);
              showGuestInfoDialog(context, index, widget.userWedding.weddingId);
            },
          );
        },
      ),
    );
  }

  Future<void> showGuestInfoDialog(
      BuildContext context, int index, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String _name = widget.guests[index].name;
          String _description = widget.guests[index].description;
          String _phone = widget.guests[index].phone;
          int _status = widget.guests[index].status;
          int groupStt = _status;
          int _type = widget.guests[index].type;
          int groupType = _type;
          int _companion = widget.guests[index].companion;
          String _congrat = widget.guests[index].congrat;
          int _money = widget.guests[index].money;
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
                              checkExistedPhoneToUpdate(widget.guests, input, index)) {
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
                      child: Text('Lưu'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          updateGuest(
                              context,
                              widget.guests[index].id,
                              _name,
                              _description,
                              _status,
                              _phone,
                              _type,
                              _companion,
                              _congrat,
                              _money,
                              weddingId);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  TextButton(
                    child: Text('Xóa'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        confirmDeleteDialog(context, index, weddingId);
                      }
                    },
                  ),
                  TextButton(
                    child: Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
          });
        });
  }

  Future<void> showGuestMoneyDialog(
      BuildContext context, int index, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String _name = widget.guests[index].name;
          String _description = widget.guests[index].description;
          String _phone = widget.guests[index].phone;
          int _status = widget.guests[index].status;
          int groupStt = _status;
          int _type = widget.guests[index].type;
          int groupType = _type;
          int _companion = widget.guests[index].companion;
          String _congrat = widget.guests[index].congrat;
          int _money = widget.guests[index].money;
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
                      Text(
                        _name,
                      ),
                      Text(
                        _description,
                      ),
                      Text(
                        _phone,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_outlined),
                          Text(
                            getType(widget.guests[index].type),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.amber,
                          ),
                          Text('Số tiền mừng:'),
                        ],
                      ),
                      Builder(builder: (context) {
                        return Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(7),
                                  ],
                                  textAlign: TextAlign.end,
                                  initialValue: _money.toString(),
                                  keyboardType: TextInputType.number,
                                  onSaved: (input) => _money = int.parse(input),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: <Widget>[
                                    Text('.000vnđ'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Builder(
                    builder: (context) => TextButton(
                      child: Text('Lưu'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          updateGuest(
                              context,
                              widget.guests[index].id,
                              _name,
                              _description,
                              _status,
                              _phone,
                              _type,
                              _companion,
                              _congrat,
                              _money,
                              weddingId);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  TextButton(
                    child: Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
          });
        });
  }

  Future<void> confirmDeleteDialog(
      BuildContext context, int index, String weddingId) async {
    return await showDialog(
        context: context,
        builder: (context) {
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
                title: Text('Bạn muốn xóa:'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(widget.guests[index].name),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Builder(
                    builder: (context) => TextButton(
                      child: Text('Có'),
                      onPressed: () {
                        deleteGuest(
                            context, widget.guests[index].id, weddingId);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  TextButton(
                    child: Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          });
        });
  }

  void updateGuest(
      var context,
      String id,
      String name,
      String description,
      int status,
      String phone,
      int type,
      int companion,
      String congrat,
      int money,
      String weddingId) {
    Guest guest = new Guest(
        name, description, status, phone, type, companion, congrat, money,
        id: id);
    BlocProvider.of<GuestsBloc>(context)..add(UpdateGuest(guest, weddingId));
  }

  void deleteGuest(BuildContext context, String guestId, String weddingId) {
    Guest guest = new Guest("", "", 0, "", 0, 0, "", 0, id: guestId);
    BlocProvider.of<GuestsBloc>(context)..add(DeleteGuest(guest, weddingId));
  }
}
