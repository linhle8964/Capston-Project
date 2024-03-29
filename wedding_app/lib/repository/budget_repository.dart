import 'package:wedding_app/model/budget.dart';

abstract class BudgetRepository {
  Future<void> createBudget(String weddingId, Budget budget);

  Future<void> updateBudget(String weddingId, Budget budget);

  Stream<List<Budget>> getBudgetByCateId(String weddingId, String cateId);

  Future<void> deleteBudget(String weddingId, String budgetId);
  Stream<List<Budget>> getAllBudget(String weddingId);
}
