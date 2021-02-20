import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/model/wedding.dart';

abstract class BudgetRepository {
  Future<void> createBudget(String WeddingId, Budget budget);

  Future<void> updateBudget(Wedding wedding, Budget budget);

  Stream<List<Budget>> getBudgetByCateId(String weddingId,String cateId);

  Future<void> deleteBudget(Wedding wedding, Budget budget);
}
