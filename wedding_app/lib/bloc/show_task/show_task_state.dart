import 'dart:async';

abstract class Month {
}


class MonthLoading extends Month {
  int number;

  MonthLoading({this.number});
}

class MonthMovedToNext extends Month {
  int number;
  MonthMovedToNext(this.number);
}

class MonthMovedPreviously extends Month {
  int number;
  MonthMovedPreviously(this.number);
}
