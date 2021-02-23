import 'dart:async';

abstract class ShowMonth  {
}

class ShowNext extends ShowMonth {
  int number;
  ShowNext(this.number);
}

class ShowPrevious extends ShowMonth {}
