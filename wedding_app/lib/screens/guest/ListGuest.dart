import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/hex_color.dart';

import '../../model/guest.dart';

class ListGuest extends StatefulWidget {
  final List<Guest> guests;
  final String weddingId;

  ListGuest(this.guests, this.weddingId);

  @override
  _ListGuestState createState() => _ListGuestState();
}

class _ListGuestState extends State<ListGuest> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String getStatus(int stt) {
    if (stt == 0)
      return "Chưa trả lời";
    else if (stt == 1)
      return "Sẽ tới";
    else
      return "Không tới";
  }

  String getColor(int stt) {
    if (stt == 0)
      return "#6eb5ff";
    else if (stt == 1)
      return "#85e3ff";
    else
      return "#ff9cee";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: ListView.builder(
        itemCount: widget.guests.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                elevation: 5,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          widget.guests[index].name,
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          widget.guests[index].description,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                    color: hexToColor(
                                        getColor(widget.guests[index].status)),
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                        ],
                      ),
                    ),
                  ],
                )),
            onTap: () {
              print(widget.guests[index].name);
              showGuestInfoDialog(context, index, widget.weddingId);
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
          int group = _status;
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
                                  onChanged: (T) {
                                    _status = T;
                                    setState(() {
                                      group = T;
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
                                  groupValue: group,
                                  onChanged: (T) {
                                    _status = T;
                                    setState(() {
                                      group = T;
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
                                  groupValue: group,
                                  onChanged: (T) {
                                    _status = T;
                                    setState(() {
                                      group = T;
                                    });
                                  }),
                              Text("Không tới"),
                            ],
                          )),
                        ],
                      ),
                      TextFormField(
                        initialValue: _phone,
                        decoration: InputDecoration(
                          labelText: "Điện thoại",
                          fillColor: Colors.white,
                          filled: true,
                        ),
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
                          updateGuest(context, widget.guests[index].id, _name,
                              _description, _status, _phone, weddingId);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) => TextButton(
                      child: Text('Xóa'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          deleteGuest(
                              context, widget.guests[index].id, weddingId);
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

  void updateGuest(var context, String id, String name, String description,
      int status, String phone, String weddingId) {
    //nang edit
    Guest guest = new Guest(name, description, status, phone,0,"",0,1, id: id);
    //
    BlocProvider.of<GuestsBloc>(context)..add(UpdateGuest(guest, weddingId));
  }

  void deleteGuest(BuildContext context, String guestId, String weddingId) {
    // nang edit
    Guest guest = new Guest("", "", 0, "",0,"",0,1, id: guestId);
    //
    BlocProvider.of<GuestsBloc>(context)..add(DeleteGuest(guest, weddingId));
  }
}
