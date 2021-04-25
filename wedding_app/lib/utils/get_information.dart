
String getStatus(int stt) {
  if (stt == 0)
    return "Chưa trả lời";
  else if (stt == 1)
    return "Sẽ tới";
  else
    return "Không tới";
}

String getType(int type) {
  if (type == 0)
    return "Chưa sắp xếp";
  else if (type == 1)
    return "Nhà trai";
  else
    return "Nhà gái";
}

String getColor(int stt) {
  if (stt == 0)
    return "#6eb5ff";
  else if (stt == 1)
    return "#85e3ff";
  else
    return "#ff9cee";
}