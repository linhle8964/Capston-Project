import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:wedding_app/screens/choose_template_invitation/chooseTemplate_page.dart';


class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final Color main_color = Colors.black26;
  int endTime = DateTime(2021, 3, 1, 7, 30, 00).millisecondsSinceEpoch;
  @override
  void initState() {
    super.initState();
  }
  void onTime(){
    print('Married');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home screen',
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Cung hỉ')
        ),
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/home_top.jpg'),
                        fit: BoxFit.cover),
                  ),
                  height: 180,
                  alignment: Alignment.center,
                  child: CountdownTimer(
                    endTime: endTime,
                    widgetBuilder: (_, CurrentRemainingTime time) {
                      if (time == null) {
                        return Text('Game over');
                      }
                      return Text(
                        ' ${(time.days==null)?'':(time.days.toString() + ' ngày,')}  ${(time.hours==null)?'0':time.hours} :  ${(time.min==null)?'0':time.min} : ${time.sec}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38
                        ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'Chia sẻ quyền quản lý',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(color: main_color, width: 2)
                                ),
                              ),
                              onPressed: (){
                                print('Share');
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButtonColumn(main_color, Icons.add_rounded, 'KHÁCH MỜI'),
                      _buildButtonColumn(main_color, Icons.assignment_ind_outlined, 'THIỆP MỜI'),
                      _buildButtonColumn(main_color, Icons.add_alarm, 'THÔNG BÁO'),
                      ElevatedButton(
                        child: Text('Open route'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChooseTemplatePage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoColumn(main_color, 'Việc cần làm ', 0),
                      _buildInfoColumn(main_color, 'Việc đã xong ', 0),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoColumn(main_color, 'Tổng ngân sách ', 0),
                      _buildInfoColumn(main_color, 'Đã dùng ', 0),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoColumn(main_color, 'Số khách dự kiến ', 0),
                      _buildInfoColumn(main_color, 'Khách đã xác nhận ', 0),
                    ],
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       _buildInfoColumn(main_color, 'Tổng dịch vụ ', 0),
                //       _buildInfoColumn(main_color, 'Đã đặt ', 0),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  Column _buildInfoColumn(Color color, String label, int amount){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    amount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }
}