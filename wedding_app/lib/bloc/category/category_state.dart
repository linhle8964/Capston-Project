import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/category_model.dart';

@immutable
abstract class CategoryState extends Equatable {

  CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInProgress extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<Category> categories;


  CategoryLoadSuccess([this.categories = const []]);

  @override
  List<Object> get props => [categories];

  @override
  String toString() {
    return 'CategoryLoadSuccess{tasks: $categories}';
  }
}

class CategoryLoadFailure extends CategoryState {}
