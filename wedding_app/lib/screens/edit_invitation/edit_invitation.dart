import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(EditInvitationPage());
}

class EditInvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EditInvitationPage',
      home: EditInvitation(),
    );
  }
}

class EditInvitation extends StatefulWidget {
  @override
  _EditInvitationState createState() => _EditInvitationState();
}

class _EditInvitationState extends State<EditInvitation> {
  @override
  Widget build(BuildContext context) {
    final screenSide= MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: null,
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
            child: Text(
              "THIỆP MỜI",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: null,
              tooltip: "Check",
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenSide.width,
              height: screenSide.height,
              child:  Image.asset('assets/edit_invitation/template4.jpg',height: 30.0,)
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(icon: Image.asset('assets/edit_invitation/edit_icon.png',height: 30.0,), onPressed: () {},),
              PopupMenuButton(
                icon: Image.asset('assets/edit_invitation/font_icon.png',height: 30.0,),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Arimo",style: TextStyle(fontFamily: 'Roboto'),),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Great viber",style: TextStyle(fontFamily: 'Times New Roman'),),
                  ),
                ],
              ),
              PopupMenuButton(
                icon: Image.asset('assets/edit_invitation/size_icon.png',height: 30.0,),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Facebook"),
                  ),
                ],
              ),
              PopupMenuButton(
                icon: Image.asset('assets/edit_invitation/color_icon.png',height: 30.0,),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Center(
                        child: IconButton(icon: Image.asset('assets/edit_invitation/red_icon.png',height: 20.0,), onPressed: () {},)
                    )
                  ),
                  PopupMenuItem(
                    value: 2,
                      child: Center(
                          child:IconButton(icon: Image.asset('assets/edit_invitation/orange_icon.png',height: 20.0,), onPressed: () {},)
                      )
                  ),
                  PopupMenuItem(
                      value: 3,
                      child: Center(
                          child: IconButton(icon: Image.asset('assets/edit_invitation/blue_icon.png',height: 20.0,), onPressed: () {},)
                      )

                  ),
                ],
              ),
              PopupMenuButton(
                icon: Image.asset('assets/edit_invitation/align_icon.png',height: 30.0,),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                      child: Center(
                        child: IconButton(icon: Image.asset('assets/edit_invitation/left_align.png',height: 20.0,), onPressed: () {},),
                      )
                  ),
                  PopupMenuItem(
                    value: 2,
                      child: Center(
                        child: IconButton(icon: Image.asset('assets/edit_invitation/center_align.png',height: 20.0,), onPressed: () {},),
                      )
                  ),
                  PopupMenuItem(
                      value: 2,
                      child: Center(
                        child: IconButton(icon: Image.asset('assets/edit_invitation/right_align.png',height: 20.0,), onPressed: () {},),
                      )
                  ),
                ],
              ),

            ],
          ),
        )
    );
  }
}

void onRedClick(){}
