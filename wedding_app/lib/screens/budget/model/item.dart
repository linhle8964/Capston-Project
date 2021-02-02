



class Item{
  String __itemName;
  int  _cost;
  Item(this.__itemName,this._cost);

  int get cost => _cost;

  set cost(int value) {
    _cost = value;
  }

  String get itemName => __itemName;

  set _itemName(String value) {
    __itemName = value;
  }
}