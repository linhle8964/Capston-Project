import 'package:flutter/material.dart';
import 'package:wedding_app/utils/hex_color.dart';

class InviteCollaboratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Mời cộng tác viên'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Email"), Text("Quyền truy cập")],
            ),
            Divider(
              height: 10.0,
              color: Colors.black,
              thickness: 10.0,
            ),
            ListView.builder(itemBuilder: null)
          ],
        ),
      ),
    );
  }
}
