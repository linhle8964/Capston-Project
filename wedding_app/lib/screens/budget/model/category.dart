
import 'package:wedding_app/screens/Budget/model/item.dart';
class category{
  String _header;
  List<Item>_items;
  category(this._header, this._items);

  List<Item> get items => _items;

  set items(List<Item> value) {
    _items = value;
  }

  String get header => _header;

  set header(String value) {
    _header = value;
  }
}