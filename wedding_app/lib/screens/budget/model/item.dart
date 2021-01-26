



class Item{
  String __itemName;
  double  _cost;
  Item(this.__itemName,this._cost);

  double get cost => _cost;

  set cost(double value) {
    _cost = value;
  }

  String get itemName => __itemName;

  set _itemName(String value) {
    __itemName = value;
  }
}