import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/model/category_model.dart';
import 'package:wedding_app/repository/category_repository.dart';
import 'bloc.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({@required this.categoryRepository}) : super(CategoryLoadSuccess());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if(event is CategoryLoadedSuccess){
      yield* _mapCategoryLoadedSuccessToState();
    }
  }

  Stream<CategoryState> _mapCategoryLoadedSuccessToState() async* {
    try {
      final categories = await this.categoryRepository.getCategories();
      List<Category> categoriesList = [];
      categories.listen((listOfCategories) {
        for (Category cate in listOfCategories) {
          categoriesList.add(cate);
          print(cate.name.toString());
        }
      });
      yield CategoryLoadSuccess(categoriesList);
    } catch (_) {
      yield CategoryLoadFailure();
    }
  }

  @override
  Future<void> close() {
     super.close();
  }
}
