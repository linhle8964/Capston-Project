import 'package:flutter/material.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:flutter_web_diary/screen/widgets/image_show/image_show.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      body: CenteredView(
        child: ShowImage(src: "assets/thanks.jpg", isFromAssets: true,),
        ),
    );
  }
}
