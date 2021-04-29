import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/format_number.dart';
import 'package:wedding_app/utils/get_information.dart';

import '../../model/guest.dart';

class ListGuestMoney extends StatefulWidget {
  final List<Guest> guests;
  final String weddingId;

  ListGuestMoney(this.guests, this.weddingId);

  @override
  _ListGuestMoneyState createState() => _ListGuestMoneyState();
}

class _ListGuestMoneyState extends State<ListGuestMoney> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _moneyPart(Guest guest) {
    return Builder(builder: (context) {
      return Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(right: 5)),
          Text(
            formatCurrency(guest.money.toString() + '000'),
          ),
          Icon(
            Icons.monetization_on_outlined,
            color: Colors.amber,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 190,
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _moneyPart(widget.guests[index]),
                          Padding(padding: EdgeInsets.only(right: 10)),
                        ],
                      ),
                    ),
                  ],
                )),
            onTap: () {
              print(widget.guests[index].name);
              showGuestMoneyDialog(context, index, widget.weddingId);
            },
          );
        },
      ),
    );
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
}
