import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CategoryEvent extends Equatable{
  @override
  List<Object> get props => [];

  CategoryEvent();
}

class CategoryLoadedSuccess extends CategoryEvent{}
