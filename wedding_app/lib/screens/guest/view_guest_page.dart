import 'package:flutter/material.dart';
import 'Guest.dart';
import 'ListGuest.dart';

class ViewGuestPage extends StatefulWidget {
  List<Guest> guests = List<Guest>();

  ViewGuestPage({
    @required this.guests,
  });

  _ViewGuestPageState createState() => _ViewGuestPageState();
}
class _ViewGuestPageState extends State<ViewGuestPage> with WidgetsBindingObserver{
  List<Guest> _guests = List<Guest>();
  List<Guest> _filterguests = List<Guest>();
  int c1 = 0, c2 = 0, c0 = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _guests = widget.guests;
    _filterguests = _guests;
    c0 = _guests.where((_guest) => _guest.status == 0).toList().length;
    c1 = _guests.where((_guest) => _guest.status == 1).toList().length;
    c2 = _guests.where((_guest) => _guest.status == 2).toList().length;
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused){

    }else if(state == AppLifecycleState.resumed){

    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task 2',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Khách mời'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                print('share');
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                print('search');
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Mời thêm khách',
          child: Icon(Icons.add),
          onPressed: (){
            print('invite guest');
          },
        ),
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(
                                  '$c1',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Sẽ tới',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]
                          ),
                          color: Colors.green,
                          height: 60,
                          onPressed: (){
                            print('coming');
                            this.setState(() {
                              _filterguests= _guests.where((_guest) => _guest.status == 1).toList();
                            });
                          },
                        )
                    ),
                    Expanded(
                        child: FlatButton(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(
                                  '$c2',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Không tới',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]
                          ),
                          color: Colors.red,
                          height: 60,
                          onPressed: (){
                            print('not coming');
                            this.setState(() {
                              _filterguests= _guests.where((_guest) => _guest.status == 2).toList();
                            });
                          },
                        )
                    ),
                    Expanded(
                        child: FlatButton(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(
                                  '$c0',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Đang mời',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]
                          ),
                          color: Colors.yellow,
                          height: 60,
                          onPressed: (){
                            print('waiting');
                            this.setState(() {
                              _filterguests= _guests.where((_guest) => _guest.status == 0).toList();
                            });
                          },
                        )
                    ),
                    Expanded(
                        child: FlatButton(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(
                                  '${c0+c1+c2}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Tổng',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]
                          ),
                          color: Colors.pinkAccent,
                          height: 60,
                          onPressed: (){
                            print('total');
                            this.setState(() {
                              _filterguests= _guests;
                            });
                          },
                        )
                    ),
                  ],
                ),
                ListGuest(guests: _filterguests,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}