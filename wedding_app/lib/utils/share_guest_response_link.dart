import 'package:flutter/material.dart';
import 'package:share/share.dart';

void shareGuestResponseLink(BuildContext context, String weddingId) async {
  final RenderBox box = context.findRenderObject();
  await Share.share("https://nangld290498.github.io/VVWED/guest/$weddingId",
      subject: "Xin hãy nhấn vào link này để gửi phản hồi",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}
