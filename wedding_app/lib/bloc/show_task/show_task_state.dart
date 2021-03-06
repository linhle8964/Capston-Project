abstract class Month {}

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

class MonthDeleted extends Month {
  int number = 0;
}
